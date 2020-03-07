package quiz_3;

import java.util.Scanner;

/**
 *
 * @author Bruno Maglioni   A01700879
 */

class Phone implements Runnable {

    private int number;
    private boolean occupied;
    
    public Phone(){
        number = 123456;
        occupied = false;
    }
    
    public Phone(int number){
        this.number = number;
        occupied = true;
    }
    
    @Override
    public void run() {
        if(occupied){
            try{
                Thread.sleep(2000);
            } catch(InterruptedException e){
                System.out.println("Thread interrupted.");
                return;
            }
            occupied = false;
        }
        //System.out.println("Phone number available.");   
    }
    
    public int getNumber(){
        return this.number;
    }
    
    public boolean isAvailable(){
        return this.occupied;
    }
     
}


public class Quiz_3 {

    /**
     * @param args the command line arguments
     * @throws java.lang.InterruptedException
     */
    public static void main(String[] args) throws InterruptedException {
        Scanner input = new Scanner(System.in);
        boolean numExists = false;
        int index = 0;
        
        System.out.print("Number to call: ");
        int num = input.nextInt();
        
        Phone[] phones = new Phone[4]; // Array of phones.
        
        phones[0] = new Phone();
        phones[1] = new Phone(46897);
        phones[2] = new Phone(num);
        phones[3] = new Phone(31518);
        
        // Check if phone number typed exists
        for (int i = 0; i < phones.length; i++) {
            if (phones[i].getNumber() == num) {
                numExists = true;
                index = i;
                break;
            }
        }
        
        if(numExists){
            System.out.println("Number exist.");
            
            //Thread p1 = new Thread(phones[0]); // Caller
            Thread p2 = new Thread(phones[index]); // Number being called
            
            System.out.println("Calling...");
            
            //p1.start();
            p2.start();
            
            while(p2.isAlive()){
                p2.join(2000);
                if(!phones[index].isAvailable()){
                    System.out.println("Phone number occupied, waiting to be available...");
                }
                //p1.join(); 
            }
            
            if(!phones[index].isAvailable()){
                System.out.println("Phone number occupied, try later.");
            } else {
                System.out.println("Call connected.");
            }
        } else{
            System.out.println("Number doesn't exist.");
        }
    }
    
}
