/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package entity;

import java.io.Serializable;
import java.util.Collection;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;

/**
 *
 * @author namin
 */
@Entity
@Table(name = "Accounts", catalog = "F21603S1_MovieOnline", schema = "dbo")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Accounts.findAll", query = "SELECT a FROM Accounts a"),
    @NamedQuery(name = "Accounts.findByAccountId", query = "SELECT a FROM Accounts a WHERE a.accountId = :accountId"),
    @NamedQuery(name = "Accounts.findByUserName", query = "SELECT a FROM Accounts a WHERE a.userName = :userName"),
    @NamedQuery(name = "Accounts.findByPassword", query = "SELECT a FROM Accounts a WHERE a.password = :password"),
    @NamedQuery(name = "Accounts.findByPhoneNumber", query = "SELECT a FROM Accounts a WHERE a.phoneNumber = :phoneNumber"),
    @NamedQuery(name = "Accounts.findByGender", query = "SELECT a FROM Accounts a WHERE a.gender = :gender"),
    @NamedQuery(name = "Accounts.findByImage", query = "SELECT a FROM Accounts a WHERE a.image = :image"),
    @NamedQuery(name = "Accounts.findByEmail", query = "SELECT a FROM Accounts a WHERE a.email = :email"),
    @NamedQuery(name = "Accounts.findByRegisterDay", query = "SELECT a FROM Accounts a WHERE a.registerDay = :registerDay"),
    @NamedQuery(name = "Accounts.findByIsVip", query = "SELECT a FROM Accounts a WHERE a.isVip = :isVip"),
    @NamedQuery(name = "Accounts.findByDayVipEnd", query = "SELECT a FROM Accounts a WHERE a.dayVipEnd = :dayVipEnd"),
    @NamedQuery(name = "Accounts.findByBanned", query = "SELECT a FROM Accounts a WHERE a.banned = :banned"),
    @NamedQuery(name = "Accounts.findByReasonBan", query = "SELECT a FROM Accounts a WHERE a.reasonBan = :reasonBan")})
public class Accounts implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "accountId", nullable = false)
    private Integer accountId;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "userName", nullable = false, length = 20)
    private String userName;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 100)
    @Column(name = "password", nullable = false, length = 100)
    private String password;
    @Size(max = 15)
    @Column(name = "phoneNumber", length = 15)
    private String phoneNumber;
    @Column(name = "gender")
    private Boolean gender;
    @Size(max = 50)
    @Column(name = "image", length = 50)
    private String image;
    // @Pattern(regexp="[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?", message="Invalid email")//if the field contains email address consider using this annotation to enforce field validation
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "email", nullable = false, length = 50)
    private String email;
    @Size(max = 10)
    @Column(name = "registerDay", length = 10)
    private String registerDay;
    @Column(name = "isVip")
    private Boolean isVip;
    @Size(max = 10)
    @Column(name = "dayVipEnd", length = 10)
    private String dayVipEnd;
    @Column(name = "banned")
    private Boolean banned;
    @Size(max = 1073741823)
    @Column(name = "reasonBan", length = 1073741823)
    private String reasonBan;
    @OneToMany(mappedBy = "accountId", fetch = FetchType.LAZY)
    private Collection<AccountVipHistory> accountVipHistoryCollection;
    @OneToMany(mappedBy = "accountId", fetch = FetchType.LAZY)
    private Collection<Comments> commentsCollection;
    @OneToMany(mappedBy = "accountId", fetch = FetchType.LAZY)
    private Collection<Rating> ratingCollection;
    @JoinColumn(name = "role", referencedColumnName = "roleId")
    @ManyToOne(fetch = FetchType.LAZY)
    private Role role;
    @OneToMany(mappedBy = "accountId", fetch = FetchType.LAZY)
    private Collection<Favorites> favoritesCollection;

    public Accounts() {
    }

    public Accounts(Integer accountId) {
        this.accountId = accountId;
    }

    public Accounts(Integer accountId, String userName, String password, String email) {
        this.accountId = accountId;
        this.userName = userName;
        this.password = password;
        this.email = email;
    }

    public Integer getAccountId() {
        return accountId;
    }

    public void setAccountId(Integer accountId) {
        this.accountId = accountId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public Boolean getGender() {
        return gender;
    }

    public void setGender(Boolean gender) {
        this.gender = gender;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRegisterDay() {
        return registerDay;
    }

    public void setRegisterDay(String registerDay) {
        this.registerDay = registerDay;
    }

    public Boolean getIsVip() {
        return isVip;
    }

    public void setIsVip(Boolean isVip) {
        this.isVip = isVip;
    }

    public String getDayVipEnd() {
        return dayVipEnd;
    }

    public void setDayVipEnd(String dayVipEnd) {
        this.dayVipEnd = dayVipEnd;
    }

    public Boolean getBanned() {
        return banned;
    }

    public void setBanned(Boolean banned) {
        this.banned = banned;
    }

    public String getReasonBan() {
        return reasonBan;
    }

    public void setReasonBan(String reasonBan) {
        this.reasonBan = reasonBan;
    }

    @XmlTransient
    public Collection<AccountVipHistory> getAccountVipHistoryCollection() {
        return accountVipHistoryCollection;
    }

    public void setAccountVipHistoryCollection(Collection<AccountVipHistory> accountVipHistoryCollection) {
        this.accountVipHistoryCollection = accountVipHistoryCollection;
    }

    @XmlTransient
    public Collection<Comments> getCommentsCollection() {
        return commentsCollection;
    }

    public void setCommentsCollection(Collection<Comments> commentsCollection) {
        this.commentsCollection = commentsCollection;
    }

    @XmlTransient
    public Collection<Rating> getRatingCollection() {
        return ratingCollection;
    }

    public void setRatingCollection(Collection<Rating> ratingCollection) {
        this.ratingCollection = ratingCollection;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    @XmlTransient
    public Collection<Favorites> getFavoritesCollection() {
        return favoritesCollection;
    }

    public void setFavoritesCollection(Collection<Favorites> favoritesCollection) {
        this.favoritesCollection = favoritesCollection;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (accountId != null ? accountId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Accounts)) {
            return false;
        }
        Accounts other = (Accounts) object;
        if ((this.accountId == null && other.accountId != null) || (this.accountId != null && !this.accountId.equals(other.accountId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entity.Accounts[ accountId=" + accountId + " ]";
    }
    
}
