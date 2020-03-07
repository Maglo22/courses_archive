
package lab_3;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.concurrent.ForkJoinPool;
import java.util.concurrent.RecursiveAction;
import javax.imageio.ImageIO;

/**
 *
 * @author Bruno Maglioni Granada  A01700879
 */
public class Lab_3 extends RecursiveAction {

    private int start;
    private int length;
    private int columns;
    private BufferedImage img;
    
    public Lab_3(BufferedImage img, int start, int length, int columns){
        this.img = img;
        this.start = start;
        this.length = length;
        this.columns = columns;
    }
    
    protected void computeDirectly(){
       for (int i = start; i < start + length; i++) {
            for (int j = 0; j < columns; j++) {
                int rgb = img.getRGB(j, i);  // rgb contian all number coded within a single integer concatenaed as red/green/blue

                //use this separation to explore with different filters and effects  you need to do the invers process to encode red green blue into a single value again
                //separation of each number
                int red = rgb & 0xFF;  // & uses  0000000111 with the rgb number to eliminate all the bits but the las 3 (which represent 8 position which are used for 0 to 255 values) 
                int green = (rgb >> 8) & 0xFF;  // >> Bitwise shifts 8 positions  & makes  uses  0000000111 with the number and eliminates the rest
                int blue = (rgb >> 16) & 0xFF; // >> Bitwise shifts 16 positions  & makes  uses  0000000111 with the number and eliminates the rest

                float L = (float) (0.2126 * (float) red + 0.7152 * (float) green + 0.0722 * (float) blue);
                // (200, 200, 200) // light gray

                int color;
                color = 200 * (int) L / 255;
                color = (color << 8) | 200 * (int) L / 255;
                color = (color << 8) | 200 * (int) L / 255;

                img.setRGB(j, i, color); // sets the pixeles to specified color

            }
        }
    }
    
    protected static int threshold = 1000;
    
    @Override
    protected void compute() {
        if(length < threshold){
            computeDirectly();
            return;
        }
        
        int split = length / 2;
        
        invokeAll(new Lab_3(img, start, split, columns),
                new Lab_3(img, split, start + split, columns));
    }
    
    
    /**
     * @param args the command line arguments
     * @throws java.io.IOException
     */
    public static void main(String[] args) throws IOException {
        BufferedImage img = ImageIO.read(new File("C:\\Users\\b_mg9\\Documents\\ITESM\\Semestre VIII\\Lenguajes de Programación\\lenguajes_programacion\\labs\\Java\\Lab_3\\assets\\Anthem.png"));
        int rows = img.getHeight();
        int columns = img.getWidth();
        
        Lab_3 l3 = new Lab_3(img, 0, rows, columns);
        
        ForkJoinPool pool = new ForkJoinPool();
        
        long startTime = System.currentTimeMillis();
        pool.invoke(l3);
        long endTime = System.currentTimeMillis();

        ImageIO.write(img, "png", new File("C:\\Users\\b_mg9\\Documents\\ITESM\\Semestre VIII\\Lenguajes de Programación\\lenguajes_programacion\\labs\\Java\\Lab_3\\outputs\\Output.png"));
        System.out.println("Finished");
        System.out.println("Applying gray filter took " + (endTime - startTime) + " milliseconds.");
    }
 
}
