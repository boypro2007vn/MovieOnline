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
@Table(name = "TypeVip", catalog = "F21603S1_MovieOnline", schema = "dbo")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "TypeVip.findAll", query = "SELECT t FROM TypeVip t"),
    @NamedQuery(name = "TypeVip.findByTypeVipId", query = "SELECT t FROM TypeVip t WHERE t.typeVipId = :typeVipId"),
    @NamedQuery(name = "TypeVip.findByName", query = "SELECT t FROM TypeVip t WHERE t.name = :name"),
    @NamedQuery(name = "TypeVip.findByDuration", query = "SELECT t FROM TypeVip t WHERE t.duration = :duration"),
    @NamedQuery(name = "TypeVip.findByPrice", query = "SELECT t FROM TypeVip t WHERE t.price = :price")})
public class TypeVip implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "typeVipId", nullable = false)
    private Integer typeVipId;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "name", nullable = false, length = 20)
    private String name;
    @Basic(optional = false)
    @NotNull
    @Column(name = "duration", nullable = false)
    private int duration;
    @Basic(optional = false)
    @NotNull
    @Column(name = "price", nullable = false)
    private double price;
    @OneToMany(mappedBy = "typeVipId", fetch = FetchType.LAZY)
    private Collection<AccountVipHistory> accountVipHistoryCollection;

    public TypeVip() {
    }

    public TypeVip(Integer typeVipId) {
        this.typeVipId = typeVipId;
    }

    public TypeVip(Integer typeVipId, String name, int duration, double price) {
        this.typeVipId = typeVipId;
        this.name = name;
        this.duration = duration;
        this.price = price;
    }

    public Integer getTypeVipId() {
        return typeVipId;
    }

    public void setTypeVipId(Integer typeVipId) {
        this.typeVipId = typeVipId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    @XmlTransient
    public Collection<AccountVipHistory> getAccountVipHistoryCollection() {
        return accountVipHistoryCollection;
    }

    public void setAccountVipHistoryCollection(Collection<AccountVipHistory> accountVipHistoryCollection) {
        this.accountVipHistoryCollection = accountVipHistoryCollection;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (typeVipId != null ? typeVipId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof TypeVip)) {
            return false;
        }
        TypeVip other = (TypeVip) object;
        if ((this.typeVipId == null && other.typeVipId != null) || (this.typeVipId != null && !this.typeVipId.equals(other.typeVipId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entity.TypeVip[ typeVipId=" + typeVipId + " ]";
    }
    
}
