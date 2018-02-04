/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package bean;

import entity.Notifications;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import javax.ejb.Stateless;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

/**
 *
 * @author namin
 */
@Stateless
public class NotificationsFacade extends AbstractFacade<Notifications> implements NotificationsFacadeLocal {
    @PersistenceContext(unitName = "MovieOnline-ejbPU")
    private EntityManager em;

    @Override
    protected EntityManager getEntityManager() {
        return em;
    }

    public NotificationsFacade() {
        super(Notifications.class);
    }

    @Override
    public Object getNotiObj(String title){
        return em.createNamedStoredProcedureQuery("Notifications.getCountNoti").setParameter("title", title).getResultList().get(0);
    }
    @Override
    public ArrayList getCountNoti() {
        ArrayList arr = new ArrayList();
        arr.add(getNotiObj("UPLOAD MOVIE"));
        arr.add(getNotiObj("PAYMENT"));
        arr.add(getNotiObj("TASK"));
        arr.add(getNotiObj("ERROR REPORT"));
        return arr;
    }

    @Override
    public boolean haveNoti(String type,boolean isRead) {
        Query q = em.createQuery("select c from Notifications c where c.isUnread = :isRead and c.type = :type").setParameter("type", type).setParameter("isRead", isRead);
        return (q.getResultList().size() > 0);
    }

    @Override
    public List<Notifications> searchNoti(int id, String title, int recipient, String type, int isread) {
        Query q = em.createNamedStoredProcedureQuery("Notifications.searchNoti")
                .setParameter("id", id)
                .setParameter("title", title)
                .setParameter("recipient", recipient)
                .setParameter("type", type)
                .setParameter("isRead", isread);
        return q.getResultList();
    }

    @Override
    public boolean checkSender(int sender, Timestamp time,String title) {
        long timeSend = time.getTime();
        Query q = em.createNativeQuery("select Top 1 * FROM Notifications n WHERE n.senderID = ?1 and n.title = ?2 order by n.notiId DESC", Notifications.class)
                .setParameter(1, sender).setParameter(2, title);
        Notifications noti = null;
        try {
            noti = (Notifications)q.getSingleResult();
            long lastTime = new Timestamp(noti.getTime().getTime()).getTime();
            return (timeSend - lastTime) < 900000;
        } catch (Exception e) {
            return false;
        }
    }
    @Override
    public List<Notifications> getCommentReport(String title) {
        Query q = em.createNamedQuery("Notifications.findByTitle");
        q.setParameter("title", title);        
        return q.getResultList();
    }
}
