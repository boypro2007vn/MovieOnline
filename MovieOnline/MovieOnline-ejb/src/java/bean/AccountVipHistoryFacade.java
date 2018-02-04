/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package bean;

import entity.AccountVipHistory;
import entity.Accounts;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;
import javax.persistence.StoredProcedureQuery;
import model.PaymentHistory;

/**
 *
 * @author namin
 */
@Stateless
public class AccountVipHistoryFacade extends AbstractFacade<AccountVipHistory> implements AccountVipHistoryFacadeLocal {
    @PersistenceContext(unitName = "MovieOnline-ejbPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public AccountVipHistoryFacade() {
        super(AccountVipHistory.class);
    }

    @Override
    public List getUserStatistic(int year) {
        Query q;
        if(year == 0){
            q = em.createNativeQuery("SELECT YEAR(h.dateRegister),ISNULL(SUM(t.price),0) FROM dbo.AccountVipHistory h JOIN dbo.TypeVip t ON t.typeVipId = h.typeVipId GROUP BY YEAR(h.dateRegister)");
        }else{
            q = em.createNativeQuery("SELECT MONTH(h.dateRegister),ISNULL(SUM(t.price),0) FROM dbo.AccountVipHistory h JOIN dbo.TypeVip t ON t.typeVipId = h.typeVipId WHERE YEAR(h.dateRegister) = ?1 GROUP BY MONTH(h.dateRegister)");
            q.setParameter(1, year);
        }
        return q.getResultList();
    }
    //get total price of all year
    @Override
    public float getTotalUserPayment() {
        Query q = em.createNativeQuery("select ISNULL(SUM(t.price),0) FROM dbo.AccountVipHistory h JOIN dbo.TypeVip t ON t.typeVipId = h.typeVipId");
        return Float.parseFloat(q.getResultList().get(0).toString());
    }

    //get number of person pay
    @Override
    public int getCountUserPayment(int year) {
        Query q;
        if(year == 0){
            q = em.createNativeQuery("select h.accountId from AccountVipHistory h GROUP BY h.accountId");
        }else{
            q = em.createNativeQuery("select h.accountId from AccountVipHistory h WHERE YEAR(h.dateRegister) = ?1 GROUP BY h.accountId");
            q.setParameter(1, year);
        }
        return q.getResultList().size();
    }

    @Override
    public int countAccountVipHistoryByDay(String day) {
        Query q = em.createNativeQuery("SELECT ISNULL(count(historyId),0) AS acchistory FROM dbo.AccountVipHistory WHERE dateRegister = ?1");
        q.setParameter(1, day);
        return Integer.parseInt(q.getSingleResult().toString());
    }

    @Override
    public List<AccountVipHistory> getListByUser(Accounts acc) {
        Query q = em.createQuery("select a from AccountVipHistory a WHERE a.accountId = :accountId ORDER BY a.historyId DESC").setParameter("accountId", acc);
        return q.getResultList();
    }
    
    @Override
    public List<PaymentHistory> getHistoryPaymentDetail() {
        Query q = em.createNativeQuery("select h.historyId, h.dateRegister, t.duration, t.price, h.accountId from dbo.AccountVipHistory h JOIN dbo.TypeVip t ON t.typeVipId = h.typeVipId",PaymentHistory.class);
        return (List<PaymentHistory>)q.getResultList();
    }

    @Override
    public List<AccountVipHistory> getPaymentByDayRange(String start, String end) {
        StoredProcedureQuery q = em.createNamedStoredProcedureQuery("AccountVipHistory.getListPaymentByDayRange").setParameter("start", start).setParameter("end", end);
        return q.getResultList();
    }
    
    
    
}
