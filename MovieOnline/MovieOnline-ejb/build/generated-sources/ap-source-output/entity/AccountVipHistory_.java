package entity;

import entity.Accounts;
import entity.TypeVip;
import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="EclipseLink-2.5.0.v20130507-rNA", date="2018-01-08T10:11:05")
@StaticMetamodel(AccountVipHistory.class)
public class AccountVipHistory_ { 

    public static volatile SingularAttribute<AccountVipHistory, String> dateRegister;
    public static volatile SingularAttribute<AccountVipHistory, TypeVip> typeVipId;
    public static volatile SingularAttribute<AccountVipHistory, Accounts> accountId;
    public static volatile SingularAttribute<AccountVipHistory, Integer> historyId;

}