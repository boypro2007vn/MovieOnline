/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package bean;

import entity.TypeVip;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

/**
 *
 * @author namin
 */
@Stateless
public class TypeVipFacade extends AbstractFacade<TypeVip> implements TypeVipFacadeLocal {
    @PersistenceContext(unitName = "MovieOnline-ejbPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public TypeVipFacade() {
        super(TypeVip.class);
    }
    
    @Override
    public TypeVip searchByPrice(double price) {
        Query q = em.createNamedQuery("TypeVip.findByPrice");
        q.setParameter("price", price);
        return (TypeVip) q.getSingleResult();
    }
    @Override
    public TypeVip searchById(String id) {
        Query q = em.createNamedQuery("TypeVip.findByTypeVipId");
        q.setParameter("typeVipId", id);
        return (TypeVip) q.getSingleResult();
    }

    @Override
    public boolean searchByName(String name) {
        Query q = em.createNamedQuery("TypeVip.findByName");
        q.setParameter("name", name);
        return q.getResultList().size() >0;
        
    }
    
}
