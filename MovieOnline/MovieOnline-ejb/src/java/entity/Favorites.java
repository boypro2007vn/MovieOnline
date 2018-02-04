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
import javax.xml.bind.annotation.XmlRootElement;
import model.MovieDB;

/**
 *
 * @author namin
 */
@Entity
@Table(name = "Favorites", catalog = "F21603S1_MovieOnline", schema = "dbo")
@XmlRootElement
@NamedStoredProcedureQueries({
    @NamedStoredProcedureQuery(
            name = "Movies.getMovieBox",
            procedureName = "getMovieBox",
            resultClasses = MovieDB.class,
            parameters = {@StoredProcedureParameter(name = "userID",mode = ParameterMode.IN,type = Integer.class)}
    ),
})
@NamedQueries({
    @NamedQuery(name = "Favorites.findAll", query = "SELECT f FROM Favorites f"),
    @NamedQuery(name = "Favorites.findByAccountId", query = "SELECT f FROM Favorites f where f.accountId = :accountId"),
    @NamedQuery(name = "Favorites.findByAccountIdandMovieId", query = "SELECT f FROM Favorites f where f.accountId = :accountId AND f.movieId =:movieId"),
    @NamedQuery(name = "Favorites.findByFavoriteID", query = "SELECT f FROM Favorites f WHERE f.favoriteID = :favoriteID"),
    @NamedQuery(name = "Favorites.findByType", query = "SELECT f FROM Favorites f WHERE f.type = :type"),
    @NamedQuery(name = "Favorites.findByFollowandMovie", query = "SELECT f FROM Favorites f WHERE f.follow = :follow and f.movieId= :movieId"),
    @NamedQuery(name = "Favorites.findByFollow", query = "SELECT f FROM Favorites f WHERE f.follow = :follow")})
public class Favorites implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "favoriteID", nullable = false)
    private Integer favoriteID;
    @Column(name = "type")
    private Boolean type;
    @Column(name = "follow")
    private Boolean follow;
    @JoinColumn(name = "accountId", referencedColumnName = "accountId")
    @ManyToOne(fetch = FetchType.LAZY)
    private Accounts accountId;
    @JoinColumn(name = "movieId", referencedColumnName = "movieId")
    @ManyToOne(fetch = FetchType.LAZY)
    private Movies movieId;

    public Favorites() {
    }

    public Favorites(Integer favoriteID) {
        this.favoriteID = favoriteID;
    }

    public Integer getFavoriteID() {
        return favoriteID;
    }

    public void setFavoriteID(Integer favoriteID) {
        this.favoriteID = favoriteID;
    }

    public Boolean getType() {
        return type;
    }

    public void setType(Boolean type) {
        this.type = type;
    }

    public Boolean getFollow() {
        return follow;
    }

    public void setFollow(Boolean follow) {
        this.follow = follow;
    }

    public Accounts getAccountId() {
        return accountId;
    }

    public void setAccountId(Accounts accountId) {
        this.accountId = accountId;
    }

    public Movies getMovieId() {
        return movieId;
    }

    public void setMovieId(Movies movieId) {
        this.movieId = movieId;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (favoriteID != null ? favoriteID.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Favorites)) {
            return false;
        }
        Favorites other = (Favorites) object;
        if ((this.favoriteID == null && other.favoriteID != null) || (this.favoriteID != null && !this.favoriteID.equals(other.favoriteID))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entity.Favorites[ favoriteID=" + favoriteID + " ]";
    }
    
}
