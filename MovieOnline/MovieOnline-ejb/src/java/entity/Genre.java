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
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
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
@Table(name = "Genre", catalog = "F21603S1_MovieOnline", schema = "dbo")
@XmlRootElement
@NamedQueries({
    @NamedQuery(name = "Genre.findAll", query = "SELECT g FROM Genre g"),
    @NamedQuery(name = "Genre.findByGenreId", query = "SELECT g FROM Genre g WHERE g.genreId = :genreId"),
    @NamedQuery(name = "Genre.findByGenreName", query = "SELECT g FROM Genre g WHERE g.genreName = :genreName"),
    @NamedQuery(name = "Genre.findByGenreOrder", query = "SELECT g FROM Genre g WHERE g.genreOrder = :genreOrder")})
public class Genre implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "genreId", nullable = false)
    private Integer genreId;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "genreName", nullable = false, length = 20)
    private String genreName;
    @Basic(optional = false)
    @NotNull
    @Column(name = "genre_order", nullable = false)
    private int genreOrder;
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "Movies_Genre", joinColumns = {
        @JoinColumn(name = "GenreID", referencedColumnName = "genreId")}, inverseJoinColumns = {
        @JoinColumn(name = "MovieID", referencedColumnName = "movieId")})
    private Collection<Movies> moviesCollection;

    public Genre() {
    }

    public Genre(Integer genreId) {
        this.genreId = genreId;
    }

    public Genre(Integer genreId, String genreName, int genreOrder) {
        this.genreId = genreId;
        this.genreName = genreName;
        this.genreOrder = genreOrder;
    }

    public Integer getGenreId() {
        return genreId;
    }

    public void setGenreId(Integer genreId) {
        this.genreId = genreId;
    }

    public String getGenreName() {
        return genreName;
    }

    public void setGenreName(String genreName) {
        this.genreName = genreName;
    }

    public int getGenreOrder() {
        return genreOrder;
    }

    public void setGenreOrder(int genreOrder) {
        this.genreOrder = genreOrder;
    }

    @XmlTransient
    public Collection<Movies> getMoviesCollection() {
        return moviesCollection;
    }

    public void setMoviesCollection(Collection<Movies> moviesCollection) {
        this.moviesCollection = moviesCollection;
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (genreId != null ? genreId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Genre)) {
            return false;
        }
        Genre other = (Genre) object;
        if ((this.genreId == null && other.genreId != null) || (this.genreId != null && !this.genreId.equals(other.genreId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entity.Genre[ genreId=" + genreId + " ]";
    }
    
}
