/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package entity;

import java.io.Serializable;
import java.util.Date;
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
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;
import model.MovieDB;

/**
 *
 * @author namin
 */
@Entity
@Table(name = "Notifications", catalog = "F21603S1_MovieOnline", schema = "dbo")
@XmlRootElement
@NamedStoredProcedureQueries({
    @NamedStoredProcedureQuery(
            name = "Notifications.getCountNoti",
            procedureName = "getCountNoti",
            parameters = {@StoredProcedureParameter(name = "title",mode = ParameterMode.IN,type = String.class)}
    ),
    @NamedStoredProcedureQuery(
            name = "Notifications.searchNoti",
            procedureName = "searchNoti",
            resultClasses = Notifications.class,
            parameters = {
                @StoredProcedureParameter(name = "id",mode = ParameterMode.IN,type = Integer.class),
                @StoredProcedureParameter(name = "title",mode = ParameterMode.IN,type = String.class),
                @StoredProcedureParameter(name = "recipient",mode = ParameterMode.IN,type = Integer.class),
                @StoredProcedureParameter(name = "type",mode = ParameterMode.IN,type = String.class),
                @StoredProcedureParameter(name = "isRead",mode = ParameterMode.IN,type = Integer.class),
            }
            
    )
})
@NamedQueries({
    @NamedQuery(name = "Notifications.findAll", query = "SELECT n FROM Notifications n"),
    @NamedQuery(name = "Notifications.findByNotiId", query = "SELECT n FROM Notifications n WHERE n.notiId = :notiId"),
    @NamedQuery(name = "Notifications.findBySenderID", query = "SELECT n FROM Notifications n WHERE n.senderID = :senderID"),
    @NamedQuery(name = "Notifications.findByName", query = "SELECT n FROM Notifications n WHERE n.name = :name"),
    @NamedQuery(name = "Notifications.findByEmail", query = "SELECT n FROM Notifications n WHERE n.email = :email"),
    @NamedQuery(name = "Notifications.findByRecipientID", query = "SELECT n FROM Notifications n WHERE n.recipientID = :recipientID"),
    @NamedQuery(name = "Notifications.findByTitle", query = "SELECT n FROM Notifications n WHERE n.title = :title"),
    @NamedQuery(name = "Notifications.findByContent", query = "SELECT n FROM Notifications n WHERE n.content = :content"),
    @NamedQuery(name = "Notifications.findByType", query = "SELECT n FROM Notifications n WHERE n.type = :type"),
    @NamedQuery(name = "Notifications.findByTime", query = "SELECT n FROM Notifications n WHERE n.time = :time")
    
})
public class Notifications implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "notiId", nullable = false)
    private Integer notiId;
    @Column(name = "senderID")
    private Integer senderID;
    @Size(max = 50)
    @Column(name = "name", length = 50)
    private String name;
    // @Pattern(regexp="[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?", message="Invalid email")//if the field contains email address consider using this annotation to enforce field validation
    @Size(max = 100)
    @Column(name = "email", length = 100)
    private String email;
    @Column(name = "recipientID")
    private Integer recipientID;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 100)
    @Column(name = "title", nullable = false, length = 100)
    private String title;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 1073741823)
    @Column(name = "content", nullable = false, length = 1073741823)
    private String content;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "type", nullable = false, length = 50)
    private String type;
    @Column(name = "time")
    @Temporal(TemporalType.TIMESTAMP)
    private Date time;
    @Column(name = "isUnread")
    private Boolean isUnread;
    @JoinColumn(name = "groupID", referencedColumnName = "roleId")
    @ManyToOne(fetch = FetchType.LAZY)
    private Role groupID;

    public Notifications() {
    }

    public Notifications(Integer notiId) {
        this.notiId = notiId;
    }

    public Notifications(Integer notiId, String title, String content, String type) {
        this.notiId = notiId;
        this.title = title;
        this.content = content;
        this.type = type;
    }

    public Integer getNotiId() {
        return notiId;
    }

    public void setNotiId(Integer notiId) {
        this.notiId = notiId;
    }

    public Integer getSenderID() {
        return senderID;
    }

    public void setSenderID(Integer senderID) {
        this.senderID = senderID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Integer getRecipientID() {
        return recipientID;
    }

    public void setRecipientID(Integer recipientID) {
        this.recipientID = recipientID;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Date getTime() {
        return time;
    }

    public void setTime(Date time) {
        this.time = time;
    }

    public Boolean getIsUnread() {
        return isUnread;
    }

    public void setIsUnread(Boolean isUnread) {
        this.isUnread = isUnread;
    }

    public Role getGroupID() {
        return groupID;
    }

    public void setGroupID(Role groupID) {
        this.groupID = groupID;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (notiId != null ? notiId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Notifications)) {
            return false;
        }
        Notifications other = (Notifications) object;
        if ((this.notiId == null && other.notiId != null) || (this.notiId != null && !this.notiId.equals(other.notiId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entity.Notifications[ notiId=" + notiId + " ]";
    }
    
}
