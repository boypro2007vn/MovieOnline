package entity;

import entity.AccountVipHistory;
import entity.Comments;
import entity.Favorites;
import entity.Rating;
import entity.Role;
import javax.annotation.Generated;
import javax.persistence.metamodel.CollectionAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@Generated(value="EclipseLink-2.5.0.v20130507-rNA", date="2018-01-08T10:11:05")
@StaticMetamodel(Accounts.class)
public class Accounts_ { 

    public static volatile SingularAttribute<Accounts, Integer> accountId;
    public static volatile SingularAttribute<Accounts, Boolean> isVip;
    public static volatile CollectionAttribute<Accounts, AccountVipHistory> accountVipHistoryCollection;
    public static volatile CollectionAttribute<Accounts, Favorites> favoritesCollection;
    public static volatile SingularAttribute<Accounts, String> reasonBan;
    public static volatile SingularAttribute<Accounts, String> image;
    public static volatile SingularAttribute<Accounts, String> password;
    public static volatile SingularAttribute<Accounts, Boolean> banned;
    public static volatile CollectionAttribute<Accounts, Comments> commentsCollection;
    public static volatile SingularAttribute<Accounts, String> registerDay;
    public static volatile SingularAttribute<Accounts, String> phoneNumber;
    public static volatile SingularAttribute<Accounts, String> email;
    public static volatile SingularAttribute<Accounts, Boolean> gender;
    public static volatile SingularAttribute<Accounts, String> userName;
    public static volatile SingularAttribute<Accounts, Role> role;
    public static volatile SingularAttribute<Accounts, String> dayVipEnd;
    public static volatile CollectionAttribute<Accounts, Rating> ratingCollection;

}