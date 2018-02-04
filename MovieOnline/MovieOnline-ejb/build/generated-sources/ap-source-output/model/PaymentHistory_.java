package model;

import javax.annotation.Generated;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="EclipseLink-2.5.0.v20130507-rNA", date="2018-01-08T10:11:05")
@StaticMetamodel(PaymentHistory.class)
public class PaymentHistory_ { 

    public static volatile SingularAttribute<PaymentHistory, String> dateRegister;
    public static volatile SingularAttribute<PaymentHistory, Integer> duration;
    public static volatile SingularAttribute<PaymentHistory, Double> price;
    public static volatile SingularAttribute<PaymentHistory, Integer> accountId;
    public static volatile SingularAttribute<PaymentHistory, Integer> historyId;

}