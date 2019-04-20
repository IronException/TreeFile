

public void setup(){
  
  
  byte[] bytes = new byte[]{
    (byte) 0x00,
    (byte) 0x82,
    (byte) 0x90,
    (byte) 0x65,
    (byte) 0xFF
    
    
  };
  
  bytes = new byte[0];
  
  
  AttributeSet tf = new AttributeSet();
  tf.load(bytes);
  tf.put("lol", new Type().setAttributeSet(tf));
  println("well");
  bytes = tf.getData();
  println(bytes);
  tf.load(bytes);
  println("----");
  println(tf.getType("lol", new Type()).getBytes());
  
  noLoop();
}