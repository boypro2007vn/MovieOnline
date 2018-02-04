/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package entity;

import java.io.Serializable;
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
import javax.persistence.NamedStoredProcedureQueries;
import javax.persistence.NamedStoredProcedureQuery;
import javax.persistence.ParameterMode;
import javax.persistence.StoredProcedureParameter;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author namin
 */
@Entity
@Table(name = "AccountVipHistory", catalog = "F21603S1_MovieOnline", schema = "dbo")
@XmlRootElement
@NamedStoredProcedureQueries({
    @NamedStoredProcedureQuery(
            name = "AccountVipHistory.getListPaymentByDayRange",
            procedureName = "getListPaymentByDayRange",
            resultClasses = AccountVipHistory.class,
            parameters = {
                @StoredProcedureParameter(name = "start", mode = ParameterMode.IN, type = String.class),
                @StoredProcedureParameter(name = "end", mode = ParameterMode.IN, type = String.class)}
    )
})
@NamedQueries({
    @NamedQuery(name = "AccountVipHistory.findAll", query = "SELECT a FROM AccountVipHistory a"),
    @NamedQuery(name = "AccountVipHistory.findByHistoryId", query = "SELECT a FROM AccountVipHistory a WHERE a.historyId = :historyId"),
    @NamedQuery(name = "AccountVipHistory.findByDateRegister", query = "SELECT a FROM AccountVipHistory a WHERE a.dateRegister = :dateRegister")})
public class AccountVipHistory implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "historyId", nullable = false)
    private Integer historyId;
    @Size(max = 10)
    @Column(name = "dateRegister", length = 10)
    private String dateRegister;
    @JoinColumn(name = "accountId", referencedColumnName = "accountId")
    @ManyToOne(fetch = FetchType.LAZY)
    private Accounts accountId;
    @JoinColumn(name = "typeVipId", referencedColumnName = "typeVipId")
    @ManyToOne(fetch = FetchType.LAZY)
    private TypeVip typeVipId;

    public AccountVipHistory() {
    }

    public AccountVipHistory(Integer historyId) {
        this.historyId = historyId;
    }

    public Integer getHistoryId() {
        return historyId;
    }

    public void setHistoryId(Integer historyId) {
        this.historyId = historyId;
    }

    public String getDateRegister() {
        return dateRegister;
    }

    public void setDateRegister(String dateRegister) {
        this.dateRegister = dateRegister;
    }

    public Accounts getAccountId() {
        return accountId;
    }

    public void setAccountId(Accounts accountId) {
        this.accountId = accountId;
    }

    public TypeVip getTypeVipId() {
        return typeVipId;
    }

    public void setTypeVipId(TypeVip typeVipId) {
        this.typeVipId = typeVipId;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (historyId != null ? historyId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof AccountVipHistory)) {
            return false;
        }
        AccountVipHistory other = (AccountVipHistory) object;
        if ((this.historyId == null && other.historyId != null) || (this.historyId != null && !this.historyId.equals(other.historyId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entity.AccountVipHistory[ historyId=" + historyId + " ]";
    }
    
    
}
