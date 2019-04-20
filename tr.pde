
public class Type {
  
  public Type(){
    this(new byte[0]);
  }
  
  public Type(byte[] data){
    this.data = data;
    as = null;
  }
  
  public byte[] getDataWithFrame(){
    byte[] lenB = getLenBytes();
    byte[] rV = new byte[2 + lenB.length + this.data.length];
    int ind = 0;
    rV[ind] = (byte) 0x00;
    ind ++;
    
    for(int i = 0; i < lenB.length; i ++){
      rV[ind] = lenB[i];
      ind ++;
    }
    
    for(int i = 0; i < this.data.length; i ++){
      rV[ind] = this.data[i];
      ind ++;
    }
    
    rV[ind] = (byte) 0xFF;
    ind ++;
    
    return rV;
  }
  
  public byte[] getLenBytes(){
    int len = this.data.length;
    byte[] lenB = new byte[]{
      (byte) ((len >> 28) & 0x7F),
      (byte) ((len >> 21) & 0x7F),
      (byte) ((len >> 14) & 0x7F),
      (byte) ((len >> 7) & 0x7F),
      (byte) ((len | 0x80) & 0xFF)
    };
    
    byte[] rV = null;
    int offset = -1;
    for(int i = 0; i < lenB.length; i ++){
      if(offset == -1){
        if(lenB[i] == (byte) 0x00)
          continue;
        offset = i;
        rV = new byte[lenB.length - i];
      }
      rV[i - offset] = lenB[i];
      
      
    }
    
    return rV;
  }
  // --------
  byte[] data;
  TreeFile tf;
  
  
  public TreeFile getTreeFile(){
    TreeFile rV = tf;
    if(rV == null)
      rV = new TreeFile().load(getData());
    return rV;
  }
  
  public Type setTreeFile(TreeFile tf){
    this.data = null;
    this.tf = tf;
    return this;
  }
  
  public Attribute getAttribute(){
    Attrubute rV = tf;
    if(rV == null)
      rV = new Attribute().load(getData());
    return rV;
  }
  
  public Type setAttribute(Attribute a){
    setTreeFile(a);
    return this;
  }
  
  public AttributeSet getAttributeSet(){
    AttributeSet rV = tf;
    if(rV == null)
      rV = new AttributeSet().load(getData());
    return rV;
  }
  
  public Type setAttributeSet(AttributeSet as){
    setTreeFile(as);
    return this;
  }
  
  
  // get Time (long), bool, byte, col?, int, double, %, that special num
  
  public byte[] getBytes(){
    return getData();
  }
  
  
  public byte[] getData(){
    if(this.data == null){
      return tf.getData();
    }
    return this.data;
  }
  
  public Type setBytes(byte[] b){
    this.data = b;
    return this;
  }
  
  
  public String getString(){
    return new String(getData);
  }
  
  public Type setString(String s){
    this.data = s.getBytes();
    return this;
  }
  
  
  
}



public class TreeFile {
  
  public TreeFile(){
    this.data = new Type[0];
  }
  
  public TreeFile load(String filepath){
    return load(getBytes(filepath, new byte[0]));
  }
  
  public byte[] getBytes(String filepath, byte[] ifNull){
    byte[] rV = null;
    try{
      rV = loadBytes(filepath);
    } catch(Exception e){}
    if(rV == null){
      rV = ifNull;
    }
    return rV;
  }
  
  public void save(String filepath){
    saveBytes(filepath, getData());
  }
  
  public TreeFile load(byte[] toExtract) {
    handleData(toExtract);
    return this;
  }
  
  protected void handleData(byte[] toExtract){
    this.data = new Type[0];
    int nevSize = 0;
    byte[] nev = null;
    
    for(int i = 0; i < toExtract.length; i ++){
      if(toExtract[i] == (byte) 0x00){ // = 0000 0000
        nevSize = 0;
        continue;
      }
      
      if(toExtract[i] == (byte) 0xFF){ // = 1111 1111
        //this.data = append(this.data, new Type(nev));
        setType(this.data.length, new Type().setBytes(nev));
        nev = null;
        continue;
      }
      
      
      nevSize = addToNum(nevSize, toExtract[i]);
      
      if(getBit(toExtract[i], 0)){// extract to data
        nev = new byte[nevSize];
        
        for(int j = 0; j < nevSize && i < toExtract.length; j ++){
          i ++;
          nev[j] = toExtract[i];
          
        }
        
      } // otherwise num is bigger...
      
    }
    
    
  }
  
  
  public byte[] getData(){
    byte[][] all = new byte[0][];
    int len = 0;
    for(Type t : getTypes()){
      all = append(all, t.getDataWithFrame());
      len += all[all.length - 1].length;
    }
    
    
    int ind = 0;
    byte[] rV = new byte[len];
    for(int i = 0; i < all.length; i ++){
      for(int j = 0; j < all[i].length; j ++){
        rV[ind] = all[i][j];
        ind ++;
      }
    }
    
    return rV;
  }
  
  public Type[] data;
  
  
  
  public int addToNum(int num, byte toAdd){
    int rV = num << 7; // 0111 = 4 + 2 + 1
    rV += toAdd & 0x7F; // ?
    return rV;
  }
  

  
  public Type[] getTypes(){
    return data;
  }
  
  public void setTypes(Type[] ts){
    this.data = ts;
    
  }
  
  
  public Type getType(int i){
    makeDataBiggerIfNeeded(i + 1);
    return data[i];
  }
  
  public void setType(int i, Type t){
    makeDataBiggerIfNeeded(i + 1);
    data[i] = t;
    
  }
  
  
  protected void makeDataBiggerIfNeeded(int nevLen){
    if(nevLen <= data.length)
      return;
    Type[] old = data;
    data = new Type[nevLen];
    for(int i = 0; i < old.length; i ++){
      data[i] = old[i];
    }
    for(int i = old.length; i < data.length; i ++){
      data[i] = new Type();
    }
  }
  
  
  
}


public byte[][] append(byte[][] old, byte[] toAdd){
  byte[][] nev = new byte[old.length + 1][];
  int i;
  for(i = 0; i < old.length; i ++){
    nev[i] = old[i];
  }
  nev[i] = toAdd;
  return nev;
}

public Type[] append(Type[] old, Type toAdd){
  Type[] nev = new Type[old.length + 1];
  int i;
  for(i = 0; i < old.length; i ++){
    nev[i] = old[i];
  }
  nev[i] = toAdd;
  return nev;
}


// like as an api?
public boolean getBit(byte data, int position) {
  return ((data >> (7 - position)) & 1) == 1;
}


public void printB(byte b){
  for(int i = 0; i < 8; i ++){
    if(i % 4 == 0 && i != 0)
      print(" ");
    print(getBool(getBit(b, i)));
  }
}

public void printlnB(byte b){
  printB(b);
  println();
}

public String getBool(boolean b){
  if(b)
    return "1";
  return "0";
}