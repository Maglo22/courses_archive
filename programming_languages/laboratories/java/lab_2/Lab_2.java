package lab_2;


import java.util.Random;
import java.util.Scanner;
import java.util.concurrent.TimeUnit;


/**
 *
 * @author Bruno Maglioni A01700879
 */

class Garden implements Runnable {
    private int numPeople;
    private int maxPeople;
    
    public Garden() {
        numPeople = 0;
        maxPeople = 0;
    }
    
    public Garden(int maxPeople) {
        numPeople = 0;
        this.maxPeople = maxPeople;
    }
    
    public synchronized void increment() {
        numPeople++;
    }
    
    public synchronized void decrement() {
        numPeople--;
    }
    
    @Override
    public void run() {
        Random rand = new Random();
        
        // Number of people to visit the garden 
        int people = rand.nextInt(this.getMaxPeople());
        people += 1;
        
        for(int i = 0; i < people; i++){
            // People entering
            // Random between 1 and 2. 1 = East Door, 2 = West Door.
            int door_entrance = rand.nextInt(2); // Person enters through this door
            door_entrance += 1;

            switch(door_entrance){
                case 1:
                    System.out.println("---> Someone enters through East door.");
                    increment();
                    break;
                case 2:
                    System.out.println("---> Someone enters through Weast door.");
                    increment();
                    break;
                default:
                    System.out.println("---> Someone enters through East door.");
                    increment();
                    break;
            }
            System.out.println("Number of people inside the Garden: " + numPeople);
            
            // Sleep some time.
            int sleep = rand.nextInt(500);
            sleep += 100;
            try{
                Thread.sleep(sleep);
            } catch(InterruptedException e){
                System.out.println("Thread interrupted.");
                return;
            }
            
            // People exiting
            int door_exit = rand.nextInt(2); // Person exits through this door
            door_exit += 1; 

            switch(door_exit){
                case 1:
                    System.out.println("Someone exits through East door. --->");
                    decrement();
                    break;
                case 2:
                    System.out.println("Someone exits through Weast door. --->");
                    decrement();
                    break;
                default:
                    System.out.println("Someone exits through East door. --->");
                    decrement();
                    break;
            }
            System.out.println("Number of people inside the Garden: " + numPeople);
        }
        
    }
    
    public synchronized int getPeople() {
        return this.numPeople;
    }
    
    public int getMaxPeople() {
        return this.maxPeople;
    }
    
    public synchronized void setPeople(int numPeople) {
        this.numPeople = numPeople;
    }
    
}

public class Lab_2 {

    /**
     * @param args the command line arguments
     * @throws java.lang.InterruptedException
     */
    public static void main(String[] args) throws InterruptedException {
        
        boolean organized = true;      
        Scanner input = new Scanner(System.in);
        
        // User inputs
        System.out.print("Enter max number of visitors per door (thread): ");
    	int maxPeople = input.nextInt();
        
        Garden garden = new Garden(maxPeople); // Create the garden
        
        if(organized){
            // One thread for each door
            Thread door_1 = new Thread(garden);
            Thread door_2 = new Thread(garden);
            
            System.out.println("Garden is open..."); TimeUnit.SECONDS.sleep(1);

            door_1.start(); door_2.start(); // Start threads
            
            // Wait for threads to finish
            while(door_1.isAlive() || door_2.isAlive()){
                if(door_1.isAlive()){
                    door_1.join(100);
                }
                if(door_2.isAlive()){
                    door_2.join(100);
                }
            }

            System.out.println("Garden is closed..."); TimeUnit.SECONDS.sleep(1);
            
            System.out.println("Final number of people inside the Garden: " + garden.getPeople());
            
        } else if (!organized){
            // Let all the threads, including the main, to finish at any order
            for(int i = 0; i < maxPeople; i++){
                (new Thread(garden)).start();
            }
        }
        
    }
    
}
