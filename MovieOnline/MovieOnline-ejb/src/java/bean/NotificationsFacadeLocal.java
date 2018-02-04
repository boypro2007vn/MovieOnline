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
import javax.ejb.Local;

/**
 *
 * @author namin
 */
@Local
public interface NotificationsFacadeLocal {

    void create(Notifications notifications);

    void edit(Notifications notifications);

    void remove(Notifications notifications);

    Notifications find(Object id);

    List<Notifications> findAll();

    List<Notifications> findRange(int[] range);

    int count();

    ArrayList getCountNoti();

    boolean haveNoti(String type,boolean isRead);

    List<Notifications> searchNoti(int id, String title, int recipient, String type, int isread);

    boolean checkSender(int sender, Timestamp time,String title);
    
    Object getNotiObj(String title);
 
    List<Notifications> getCommentReport(String title);
}
