package lab_1;

//import java.util.Random;
import java.util.Scanner;
import java.util.concurrent.TimeUnit;

/**
 *
 * @author Bruno Maglioni A01700879
 */


class Animals {
    private int pace;
    private int distanceTraveled;
    private int maxDistance;
    
    public Animals(){
        pace = 0;
        distanceTraveled = 0;
        maxDistance = 0;
    }
    
    public Animals(int pace, int maxDistance){
        this.pace = pace;
        this.maxDistance = maxDistance;
        distanceTraveled = 0;
    }
    
    // Getters & Setters
    
    public int getPace(){
        return this.pace;
    }
    
    public void setPace(int pace){
        this.pace = pace;
    }
    
    public int getDistanceTraveled(){
        return this.distanceTraveled;
    }
    
    public void setDistaceTraveled(int distanceTraveled){
        this.distanceTraveled = distanceTraveled;
    }
    
    public int getMaxDistance(){
        return this.maxDistance;
    }
    
    public void setMaxDistance(int maxDistance){
        this.maxDistance = maxDistance;
    }
}

class Rabbit extends Animals implements Runnable {
    private int sleep;
    
    public Rabbit(){
        super();
        sleep = 0;
    }
    
    public Rabbit(int pace, int sleep, int maxDistance){
        super(pace, maxDistance);
        this.sleep = sleep;
    }
    
    @Override
    public void run(){
        System.out.println("Rabbit running...");
        do{
            this.setDistaceTraveled(this.getDistanceTraveled() + this.getPace());
            //System.out.println("Rabbit has traveled: " + this.getDistanceTraveled() + " feet.");
            try{
                Thread.sleep(this.sleep);
                System.out.println("Rabbit sleeping for " + this.sleep + " ms.");
            } catch(InterruptedException e){
                System.out.println("Rabbit didn't finish.");
                return;
            }
        }while(this.getDistanceTraveled() < this.getMaxDistance());
        
        System.out.println("Rabbit finished the race.");
    }
    
    // Getters & Setters
    
    public int getSleep(){
        return this.sleep;
    }
    
    public void setSleep(int sleep){
        this.sleep = sleep;
    }
}

class Turtle extends Animals implements Runnable {
    public Turtle(){
        super();
    }
    
    public Turtle(int pace, int maxDistance){
        super(pace, maxDistance);
    }
    
    @Override
    public void run(){
        System.out.println("Turtle running...");
        do{
            this.setDistaceTraveled(this.getDistanceTraveled() + this.getPace());
            //System.out.println("Turtle has traveled: " + this.getDistanceTraveled()  + " feet.");
            if (Thread.interrupted()) {
                System.out.println("Turtle didn't finish.");
                return;
            }
        }
        while(this.getDistanceTraveled() < this.getMaxDistance());
        
        System.out.println("Turtle finished the race.");
    }
    
}

public class Lab_1 {
    
    /**
     * @param args the command line arguments
     * @throws java.lang.InterruptedException
     */
    public static void main(String[] args) throws InterruptedException{
        //Random r = new Random();
        Scanner input = new Scanner(System.in);
        
        // User inputs
        System.out.print("Enter race length: ");
    	int goal = input.nextInt();
        
        System.out.print("Enter the rabbit's pace: ");
    	int rabbitPace = input.nextInt();
        
        System.out.print("Enter the rabbit's sleeping time: ");
    	int rabbitSleep = input.nextInt();
        
        System.out.print("Enter the turtle's pace: ");
    	int turtlePace = input.nextInt();
        
        // Create objects instances
        Rabbit rb = new Rabbit(rabbitPace, rabbitSleep, goal);
        Turtle tt = new Turtle(turtlePace, goal);
        
        // Create threads
        Thread rabbit = new Thread(rb);
        Thread turtle = new Thread(tt);
        
        System.out.print("\n3... "); TimeUnit.SECONDS.sleep(1);
        System.out.print("2... "); TimeUnit.SECONDS.sleep(1);
        System.out.print("1... "); TimeUnit.SECONDS.sleep(1);
        System.out.print("GO!\n");
        
        // Start threads (race)
        rabbit.start(); turtle.start();
        
        while( rabbit.isAlive() && turtle.isAlive() ){
            // Give some execution time to each thread
            rabbit.join(100);
            turtle.join(100);
            
            // Check for winner
            if(rb.getDistanceTraveled() >= goal && turtle.isAlive()){
                turtle.interrupt();
                turtle.join();
                break;
            }
            if(tt.getDistanceTraveled() >= goal && rabbit.isAlive()){
                rabbit.interrupt();
                rabbit.join();
                break;
            } 
        }
        
        System.out.println("Race over.");
    }
    
}
