/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package bean;

import entity.TypeVip;
import java.util.List;
import javax.ejb.Local;

/**
 *
 * @author namin
 */
@Local
public interface TypeVipFacadeLocal {

    void create(TypeVip typeVip);

    void edit(TypeVip typeVip);

    void remove(TypeVip typeVip);

    TypeVip find(Object id);

    List<TypeVip> findAll();

    List<TypeVip> findRange(int[] range);

    int count();
    
    TypeVip searchByPrice(double price);

    TypeVip searchById(String id);

    boolean searchByName(String name);
}
