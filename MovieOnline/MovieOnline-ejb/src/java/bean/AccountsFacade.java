/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package bean;

import entity.Accounts;
import entity.Role;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import main.Encrypt;

/**
 *
 * @author namin
 */
@Stateless
public class AccountsFacade extends AbstractFacade<Accounts> implements AccountsFacadeLocal {
    @PersistenceContext(unitName = "MovieOnline-ejbPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public AccountsFacade() {
        super(Accounts.class);
    }
    @Override
    public Accounts login(String username, String password, boolean remember) {
        Query q = em.createNamedQuery("Accounts.findByUserName");
        q.setParameter("userName", username);
        Accounts acc;
        try {
            acc = (Accounts) q.getSingleResult();
            if(acc.getPassword().equals(Encrypt.encrypt(password, false))){
                return acc;
            }
        } catch (Exception e) {
            return null;
        }
        return null;
    }

    @Override
    public Role getRole(Accounts acc) {
        return acc.getRole();
    }

    @Override
    public Accounts getAccountByUsername(String username) {
        Query q = em.createNamedQuery("Accounts.findByUserName");
        q.setParameter("userName", username);
        Accounts acc;
        try {
            acc = (Accounts) q.getSingleResult();
            return acc;
        } catch (Exception e) {
            return null;
        }
    }

    @Override
    public int countAccountByDay(String day) {
        Query q = em.createNativeQuery("SELECT ISNULL(count(accountId),0) AS acc FROM dbo.Accounts WHERE registerDay = ?1");
        q.setParameter(1, day);
        return Integer.parseInt(q.getSingleResult().toString());
    }
    
    
}
