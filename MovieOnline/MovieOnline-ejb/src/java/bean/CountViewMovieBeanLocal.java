/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package bean;

import java.util.Hashtable;
import javax.ejb.Local;

/**
 *
 * @author namin
 */
@Local
public interface CountViewMovieBeanLocal {
    void addView(int movieId);

    Hashtable<Integer,Integer> getListViewByDay();

    int getCountViewByDay();
}
