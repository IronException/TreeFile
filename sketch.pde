

public void setup(){
  
  
  //new Link().setNavi(new String[]{"", "", ""});
  
  byte[] bytes = new byte[0];
  
  
  AttributeSet tf = new AttributeSet();
  tf.load(bytes);
  tf.put("lol", new Type());
  
  printl(tf.data);
  tf.put("lol ", new Type().setLink(new Link().setNavi(new String[]{"dont worry", " ", "^", "□"})));
  bytes = tf.getData();
  println(bytes);
  println("----");
  
  tf.load(bytes);
  println(tf.getType("lol ", new Type()).getBytes());
  println("--");
  noLoop();
}


public void printl(Type[] ts){
  for(int i = 0; i < ts.length; i ++){
    println(i + ": " + ts[i]);
  }
}

