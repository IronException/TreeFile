

public class BasicAttribute extends TreeFile{
  
  
  public BasicAttribute(){
    super();
  }
  
  public BasicAttribute(String name, Type t){
    super();
    
    setName(name);
    setValue(t);
    
  }
  
  @Override
  public BasicAttribute load(byte[] b){
    super.load(b);
    return this;
  }
  
  public String getName(){
    return super.getType(0).getString();
  }
  
  public void setName(String name){
    super.getType(0).setString(name);
  }
  
  public Type getValue(){
    return super.getType(1);
  }
  
  public void setValue(Type t){
    super.setType(1, t);
  }
  
  
}


public class Attribute extends BasicAttribute{
  // is for additional values
  
  @Override
  public Attribute load(byte[] b){
    super.load(b);
    return this;
  }
  
  public Attribute(){
    super();
  }
  
  public Attribute(String name, Type t){
    super(name, t);
  }
  
  public Type getExtra(int i){
    return super.getType(2 + i);
  }
  
  public void setExtra(int i, Type t){
    super.setType(2 + i, t);
  }
  
  public int getExtraSize(){
    return super.getTypes().length - 2;
  }
  
  
}


public class AttributeSet extends TreeFile{
  
  public AttributeSet(){
    super();
    as = new HashMap<String, Attribute>();
  }
  
  public AttributeSet load(byte[] bs){
    super.load(bs);
    return this;
  }
  
  
  HashMap<String, Attribute> as;
  
  @Override
  public void setType(int i, Type t){
    put(t.getAttribute());
  }
  
  public void put(Attribute a){
    as.put(a.getName(), a);
  }
  
  public void put(String name, Type t){
    put(new Attribute(name, t));
  }
  
  public void remove(String name){
    as.remove(name);
  }
  
  public Object get(String name){
    return as.get(name);
  }
  
  public Object get(String name, Object ifNull){
    Object rV = get(name);
    if(rV == null)
      rV = ifNull;
    return rV;
  }
  
  public Attribute getAttribute(String name){
    return (Attribute) get(name);
  }
  
  public Attribute getAttribute(String name, Attribute ifNull){
    return (Attribute) get(name, ifNull);
  }
  
  public Type getValue(String name){
    return getAttribute(name).getValue();
  }
  
  public Type getValue(String name, Type ifNull, boolean put){
    Attribute rV = getAttribute(name);
    if(rV == null){
      if(put)
        this.put(name, ifNull);
      return ifNull;
    }
    return rV.getValue();
  }
  
  
  
  public Type getType(String name){
    return getValue(name);
  }
  
  public Type getType(String name, Type ifNull){
    return getValue(name, ifNull, false);
  }
  
  
  public AttributeSet getAttributeSet(String name){
    return getType(name).getAttributeSet();
  }
  
  public AttributeSet getAttributeSet(String name, AttributeSet ifNull, boolean put){
    return getValue(name, new Type().setAttributeSet(ifNull), put).getAttributeSet();
  }
  
  public AttributeSet getAttributeSet(String name, AttributeSet ifNull){
    return getAttributeSet(name, ifNull, true);
  }
  
  // TODO will this get saved?
  // guess not cuz type has to be added swhere
  
  
  public Attribute[] getAttributes(){
    return as.values().toArray(new Attribute[0]);
  }
  
  @Override
  public Type[] getTypes(){
    Attribute[] a = getAttributes();
    Type[] rV = new Type[a.length];
    for(int i = 0; i < a.length; i ++){
      rV[i] = new Type().setAttribute(a[i]);
    }
    return rV;
  }
  
  
  
  
}