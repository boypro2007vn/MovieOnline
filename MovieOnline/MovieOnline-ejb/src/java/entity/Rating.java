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
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author namin
 */
@Entity
@Table(name = "Rating", catalog = "F21603S1_MovieOnline", schema = "dbo")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Rating.findAll", query = "SELECT r FROM Rating r"),
    @NamedQuery(name = "Rating.findByRatingId", query = "SELECT r FROM Rating r WHERE r.ratingId = :ratingId"),
    @NamedQuery(name = "Rating.findByMovieIdAndAccountsId", query = "SELECT r FROM Rating r WHERE r.accountId = :accountId and r.movieId = :movieId"),
    @NamedQuery(name = "Rating.findByMovie", query = "SELECT r FROM Rating r WHERE r.movieId = :movieId"),
    @NamedQuery(name = "Rating.findByStar", query = "SELECT r FROM Rating r WHERE r.star = :star")})
public class Rating implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "ratingId", nullable = false)
    private Integer ratingId;
    @Column(name = "star")
    private Integer star;
    @JoinColumn(name = "accountId", referencedColumnName = "accountId")
    @ManyToOne(fetch = FetchType.LAZY)
    private Accounts accountId;
    @JoinColumn(name = "movieId", referencedColumnName = "movieId")
    @ManyToOne(fetch = FetchType.LAZY)
    private Movies movieId;

    public Rating() {
    }

    public Rating(Integer ratingId) {
        this.ratingId = ratingId;
    }

    public Integer getRatingId() {
        return ratingId;
    }

    public void setRatingId(Integer ratingId) {
        this.ratingId = ratingId;
    }

    public Integer getStar() {
        return star;
    }

    public void setStar(Integer star) {
        this.star = star;
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
        hash += (ratingId != null ? ratingId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Rating)) {
            return false;
        }
        Rating other = (Rating) object;
        if ((this.ratingId == null && other.ratingId != null) || (this.ratingId != null && !this.ratingId.equals(other.ratingId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entity.Rating[ ratingId=" + ratingId + " ]";
    }
    
}
