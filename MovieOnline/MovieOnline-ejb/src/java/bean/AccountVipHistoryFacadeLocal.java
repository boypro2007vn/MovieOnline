/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package bean;

import entity.AccountVipHistory;
import entity.Accounts;
import java.util.List;
import javax.ejb.Local;
import model.PaymentHistory;

/**
 *
 * @author namin
 */
@Local
public interface AccountVipHistoryFacadeLocal {

    void create(AccountVipHistory accountVipHistory);

    void edit(AccountVipHistory accountVipHistory);

    void remove(AccountVipHistory accountVipHistory);

    AccountVipHistory find(Object id);

    List<AccountVipHistory> findAll();

    List<AccountVipHistory> findRange(int[] range);

    int count();

    List getUserStatistic(int year);

    float getTotalUserPayment();

    int getCountUserPayment(int year);

    int countAccountVipHistoryByDay(String day);

    List<AccountVipHistory> getListByUser(Accounts acc);
    
    List<PaymentHistory> getHistoryPaymentDetail();

    List<AccountVipHistory> getPaymentByDayRange(String start, String end);
}
