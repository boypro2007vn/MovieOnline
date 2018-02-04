/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package bean;

import entity.Movies;
import java.util.Hashtable;
import java.util.Map;
import java.util.Set;
import javax.ejb.EJB;
import javax.ejb.Schedule;
import javax.ejb.Singleton;

/**
 *
 * @author namin
 */
@Singleton
public class CountViewMovieBean implements CountViewMovieBeanLocal {
    @EJB
    private MoviesFacadeLocal moviesFacade;
    
    private static Hashtable<Integer,Integer> listView =new Hashtable<Integer,Integer>();;
    private static Hashtable<Integer,Integer> listViewByDay =new Hashtable<Integer,Integer>();;
    
    
    @Schedule(minute = "*",hour="*", persistent = false)
    public void autoSendCountView() {
        if (listView.size() > 0) {
            for (Map.Entry<Integer, Integer> entry : listView.entrySet()) {
                try {
                    Movies movie = moviesFacade.find(entry.getKey());
                    movie.setViews(movie.getViews() + entry.getValue());
                    moviesFacade.edit(movie);
                    listView.remove(entry.getKey());
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
    }
    
    @Schedule(minute = "0",hour="0", persistent = false)
    public void autoResetViewByDay() {
        listViewByDay.clear();
        System.out.println("Reset view success");
    }
    
    @Override
    public void addView(int movieId) {
        if(listView.containsKey(movieId)){
            listView.put(movieId, listView.get(movieId)+1);
        }else{
            listView.put(movieId, 1);
        }
        
        if(listViewByDay.containsKey(movieId)){
            listViewByDay.put(movieId, listViewByDay.get(movieId)+1);
            
        }else{
            listViewByDay.put(movieId, 1);
        }
        System.out.println(listViewByDay);
    }

    @Override
    public Hashtable<Integer,Integer> getListViewByDay() {
        return listViewByDay;
    }

    @Override
    public int getCountViewByDay() {
        int count =0;
        Set<Integer> keys = listViewByDay.keySet();
        for(Integer key: keys){
            count+=listViewByDay.get(key);
        }
        return count;
    }
    
    
    
    
}
