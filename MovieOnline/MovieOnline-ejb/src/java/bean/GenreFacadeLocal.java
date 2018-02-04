/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package bean;

import entity.Genre;
import java.util.List;
import javax.ejb.Local;

/**
 *
 * @author namin
 */
@Local
public interface GenreFacadeLocal {

    void create(Genre genre);

    void edit(Genre genre);

    void remove(Genre genre);

    Genre find(Object id);

    List<Genre> findAll();

    List<Genre> findRange(int[] range);

    int count();
    
}
