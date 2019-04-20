

public class Link extends AttributeSet {
  
  public Link load(byte[] bs){
    return (Link) super.load(bs);
  }
  
  
  public Link(){
    super();
  }
  
  public String getName(){
    return getValue("name").getString();
  }
  
  public String[] getStrings(){
    // todo
    return loadStrings("// TODO");
  }
  
  public Type getType(){
    // TODO
    return null;
  }
  
  public Link setName(String name){
    put("name", new Type().setString(name));
    return this;
  }
  
  public Link setPathWithOs(boolean b){
    put("withOs", new Type().setBool(b));
    return this;
  }
  
  // is also = url
  public Link setFilepath(String filepath){
    put("filepath", new Type().setString(filepath));
    return this;
  }
  
  public Link setFilepath(String filepath, boolean withOs){
    setFilepath(filepath);
    setPathWithOs(withOs);
    return this;
  }
  
  public Link setNavi(String[] navi){
    Attribute last = new Attribute();
    Attribute rn;
    for(int i = navi.length - 1; i >= 0; i --){
      rn = new Attribute(navi[i], new Type().setAttribute(last));
      last = rn;
      
    }
    put("navi", new Type().setAttribute(last)); // TODO
    return this;
  }
  
  public void setFilepath(String filepath, boolean withOs, String[] navi){
    setFilepath(filepath, withOs);
    setNavi(navi);
  }
  
  
 
  
}