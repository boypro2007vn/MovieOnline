package entity;

import entity.AccountVipHistory;
import javax.annotation.Generated;
import javax.persistence.metamodel.CollectionAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="EclipseLink-2.5.0.v20130507-rNA", date="2018-01-08T10:11:05")
@StaticMetamodel(TypeVip.class)
public class TypeVip_ { 

    public static volatile SingularAttribute<TypeVip, Integer> typeVipId;
    public static volatile SingularAttribute<TypeVip, Integer> duration;
    public static volatile SingularAttribute<TypeVip, Double> price;
    public static volatile CollectionAttribute<TypeVip, AccountVipHistory> accountVipHistoryCollection;
    public static volatile SingularAttribute<TypeVip, String> name;

}