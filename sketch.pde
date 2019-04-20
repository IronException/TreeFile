
public String getPath(String toAdd){
  return android.os.Environment.getExternalStoragePublicDirectory(android.os.Environment.DIRECTORY_DCIM).getParentFile().getAbsolutePath() + 
  "/CODING/" + toAdd;
}

public void setup(){
  initUseProc();
  
  
  String filepath = getPath("tf/todos.tf");
  
  tf = new AttributeSet();
  tf.load(filepath);
  
  tf.put("lol", new Type().setString("u gay"));
  
  Attribute[] as = tf.getAttributes();
  
  tf.save(filepath);
  
  nextScreen(new AttributeViz(as), false);
  
}

AttributeSet tf;

AttrViz[] panels;

public void draw(){
  
  useProc.drawHelper();
  
  
}

public class AttrViz extends Panel {
  
  
  public AttrViz(Attribute a){
    this.a = a;
  }
  
  Attribute a;
  
  public void render(){
    fill(255);
    rect(xPos, yPos, xSize, ySize);
  }
  
  
}

public class AttributeViz extends Screen{
  
  
  public AttributeViz(Attribute[] as){
    super();
    
    panels = new Panel[as.length + 1];
    int i;
    for(i = 0; i < as.length; i ++){
      panels[i] = new AttrViz(as[i]);
    }
    panels[i] = new Key("add", new Runnable(){
      public void run(){
        println("// TODO add");
      }
    });
    
  }
  
  public void init(){
    super.setPosSize();
    super.init();
  }
}