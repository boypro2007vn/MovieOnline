/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package entity;

import java.io.Serializable;
import java.util.Collection;
import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.NamedStoredProcedureQueries;
import javax.persistence.NamedStoredProcedureQuery;
import javax.persistence.OneToMany;
import javax.persistence.ParameterMode;
import javax.persistence.StoredProcedureParameter;
import javax.persistence.Table;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;
import model.MovieDB;

/**
 *
 * @author namin
 */
@Entity
@Table(name = "Movies", catalog = "F21603S1_MovieOnline", schema = "dbo")
@XmlRootElement
@NamedStoredProcedureQueries({
    @NamedStoredProcedureQuery(
            name = "Movies.getDetailMovie",
            procedureName = "getDetailMovie",
            resultClasses = MovieDB.class,
            parameters = {@StoredProcedureParameter(name = "id",mode = ParameterMode.IN,type = Integer.class)}
    ),
    @NamedStoredProcedureQuery(
            name = "Movies.getListMovieByDayRange",
            procedureName = "getListMovieByDayRange",
            resultClasses = Movies.class,
            parameters = {@StoredProcedureParameter(name = "start",mode = ParameterMode.IN,type = String.class),
                          @StoredProcedureParameter(name = "end",mode = ParameterMode.IN,type = String.class)}
    ),
    @NamedStoredProcedureQuery(
            name = "Movies.getListTrailerMovie",
            procedureName = "getListTrailerMovie",
            resultClasses = MovieDB.class
    ),
    @NamedStoredProcedureQuery(
            name = "Movies.getListMovieByType",
            procedureName = "getListMovieByType",
            resultClasses = MovieDB.class,
            parameters = {@StoredProcedureParameter(name = "type",mode = ParameterMode.IN,type = Integer.class),
                            @StoredProcedureParameter(name = "num",mode = ParameterMode.IN,type = Integer.class)}
    ),
    @NamedStoredProcedureQuery(
            name = "Movies.relatedMovies",
            procedureName = "relatedMovies",
            resultClasses = MovieDB.class,
            parameters = {@StoredProcedureParameter(name = "id",mode = ParameterMode.IN,type = Integer.class),
                            @StoredProcedureParameter(name = "title",mode = ParameterMode.IN,type = String.class),
                            @StoredProcedureParameter(name = "genre",mode = ParameterMode.IN,type = String.class),
                            @StoredProcedureParameter(name = "actor",mode = ParameterMode.IN,type = String.class),
                            @StoredProcedureParameter(name = "country",mode = ParameterMode.IN,type = String.class)}
    ),
    //searchMovie Tri
    @NamedStoredProcedureQuery(
            name = "Movies.searchMovie",
            procedureName = "searchMovie",
            resultClasses = MovieDB.class,
            parameters = {@StoredProcedureParameter(name = "id",mode = ParameterMode.IN,type = Integer.class),
                            @StoredProcedureParameter(name = "title",mode = ParameterMode.IN,type = String.class),
                            @StoredProcedureParameter(name = "actor",mode = ParameterMode.IN,type = String.class),
                            @StoredProcedureParameter(name = "director",mode = ParameterMode.IN,type = String.class),
                            @StoredProcedureParameter(name = "type",mode = ParameterMode.IN,type = Integer.class),
                            @StoredProcedureParameter(name = "uploadDay",mode = ParameterMode.IN,type = Integer.class),
                            @StoredProcedureParameter(name = "releaseDay",mode = ParameterMode.IN,type = Integer.class),
                            @StoredProcedureParameter(name = "countryName",mode = ParameterMode.IN,type = String.class),                            
                            @StoredProcedureParameter(name = "genreName",mode = ParameterMode.IN,type = String.class),
                            @StoredProcedureParameter(name = "views",mode = ParameterMode.IN,type = Integer.class)}
    ),
    //Tri
    @NamedStoredProcedureQuery(
            name = "Movies.searchHeader",
            procedureName = "searchHeader",
            resultClasses = MovieDB.class,
            parameters = {@StoredProcedureParameter(name = "title",mode = ParameterMode.IN,type = String.class)}
    )    
})
@NamedQueries({
    @NamedQuery(name = "Movies.findAll", query = "SELECT m FROM Movies m"),
    @NamedQuery(name = "Movies.findByMovieId", query = "SELECT m FROM Movies m WHERE m.movieId = :movieId"),
    @NamedQuery(name = "Movies.findByTitle", query = "SELECT m FROM Movies m WHERE m.title = :title"),
    @NamedQuery(name = "Movies.findByRealTitle", query = "SELECT m FROM Movies m WHERE m.realTitle = :realTitle"),
    @NamedQuery(name = "Movies.findByTitleTag", query = "SELECT m FROM Movies m WHERE m.titleTag = :titleTag"),
    @NamedQuery(name = "Movies.findByReleaseDay", query = "SELECT m FROM Movies m WHERE m.releaseDay = :releaseDay"),
    @NamedQuery(name = "Movies.findByImdb", query = "SELECT m FROM Movies m WHERE m.imdb = :imdb"),
    @NamedQuery(name = "Movies.findByActors", query = "SELECT m FROM Movies m WHERE m.actors = :actors"),
    @NamedQuery(name = "Movies.findByActorAscii", query = "SELECT m FROM Movies m WHERE m.actorAscii = :actorAscii"),
    @NamedQuery(name = "Movies.findByDirector", query = "SELECT m FROM Movies m WHERE m.director = :director"),
    @NamedQuery(name = "Movies.findByDirectorAscii", query = "SELECT m FROM Movies m WHERE m.directorAscii = :directorAscii"),
    @NamedQuery(name = "Movies.findByDescription", query = "SELECT m FROM Movies m WHERE m.description = :description"),
    @NamedQuery(name = "Movies.findByType", query = "SELECT m FROM Movies m WHERE m.type = :type"),
    @NamedQuery(name = "Movies.findByDuration", query = "SELECT m FROM Movies m WHERE m.duration = :duration"),
    @NamedQuery(name = "Movies.findByViews", query = "SELECT m FROM Movies m WHERE m.views = :views"),
    @NamedQuery(name = "Movies.findByUploadDay", query = "SELECT m FROM Movies m WHERE m.uploadDay = :uploadDay"),
    @NamedQuery(name = "Movies.findByTrailer", query = "SELECT m FROM Movies m WHERE m.trailer = :trailer"),
    @NamedQuery(name = "Movies.findByStatus", query = "SELECT m FROM Movies m WHERE m.status = :status"),
    @NamedQuery(name = "Movies.findByQuantity", query = "SELECT m FROM Movies m WHERE m.quantity = :quantity"),
    @NamedQuery(name = "Movies.findByAgeLimit", query = "SELECT m FROM Movies m WHERE m.ageLimit = :ageLimit"),
    @NamedQuery(name = "Movies.findByVipOnly", query = "SELECT m FROM Movies m WHERE m.vipOnly = :vipOnly")})
public class Movies implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "movieId", nullable = false)
    private Integer movieId;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 100)
    @Column(name = "title", nullable = false, length = 100)
    private String title;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 100)
    @Column(name = "realTitle", nullable = false, length = 100)
    private String realTitle;
    @Size(max = 200)
    @Column(name = "titleTag", length = 200)
    private String titleTag;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 10)
    @Column(name = "releaseDay", nullable = false, length = 10)
    private String releaseDay;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Column(name = "imdb", precision = 53)
    private Double imdb;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 200)
    @Column(name = "actors", nullable = false, length = 200)
    private String actors;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 200)
    @Column(name = "actor_ascii", nullable = false, length = 200)
    private String actorAscii;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "director", nullable = false, length = 50)
    private String director;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 50)
    @Column(name = "director_ascii", nullable = false, length = 50)
    private String directorAscii;
    @Size(max = 1073741823)
    @Column(name = "description", length = 1073741823)
    private String description;
    @Column(name = "type")
    private Boolean type;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "duration", nullable = false, length = 20)
    private String duration;
    @Column(name = "views")
    private Integer views;
    @Size(max = 10)
    @Column(name = "uploadDay", length = 10)
    private String uploadDay;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 100)
    @Column(name = "trailer", nullable = false, length = 100)
    private String trailer;
    @Column(name = "status")
    private Boolean status;
    @Size(max = 10)
    @Column(name = "quantity", length = 10)
    private String quantity;
    @Column(name = "ageLimit")
    private Boolean ageLimit;
    @Column(name = "vipOnly")
    private Boolean vipOnly;
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(name = "Movies_Genre", joinColumns = {
        @JoinColumn(name = "MovieID", referencedColumnName = "movieId")}, inverseJoinColumns = {
        @JoinColumn(name = "GenreID", referencedColumnName = "genreId")})
    private Collection<Genre> genreCollection;
    @OneToMany(mappedBy = "movieId", cascade = CascadeType.REMOVE)
    private Collection<Episode> episodeCollection;
    @OneToMany(mappedBy = "movieId",cascade = CascadeType.REMOVE)
    private Collection<Comments> commentsCollection;
    @OneToMany(mappedBy = "movieId",cascade = CascadeType.REMOVE)
    private Collection<Rating> ratingCollection;
    @JoinColumn(name = "countryId", referencedColumnName = "countryId")
    @ManyToOne(fetch = FetchType.LAZY)
    private Country countryId;
    @OneToMany(mappedBy = "movieId",cascade = CascadeType.REMOVE)
    private Collection<Favorites> favoritesCollection;

    public Movies() {
    }

    public Movies(Integer movieId) {
        this.movieId = movieId;
    }

    public Movies(Integer movieId, String title, String realTitle, String releaseDay, String actors, String actorAscii, String director, String directorAscii, String duration, String trailer) {
        this.movieId = movieId;
        this.title = title;
        this.realTitle = realTitle;
        this.releaseDay = releaseDay;
        this.actors = actors;
        this.actorAscii = actorAscii;
        this.director = director;
        this.directorAscii = directorAscii;
        this.duration = duration;
        this.trailer = trailer;
    }

    public Integer getMovieId() {
        return movieId;
    }

    public void setMovieId(Integer movieId) {
        this.movieId = movieId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getRealTitle() {
        return realTitle;
    }

    public void setRealTitle(String realTitle) {
        this.realTitle = realTitle;
    }

    public String getTitleTag() {
        return titleTag;
    }

    public void setTitleTag(String titleTag) {
        this.titleTag = titleTag;
    }

    public String getReleaseDay() {
        return releaseDay;
    }

    public void setReleaseDay(String releaseDay) {
        this.releaseDay = releaseDay;
    }

    public Double getImdb() {
        return imdb;
    }

    public void setImdb(Double imdb) {
        this.imdb = imdb;
    }

    public String getActors() {
        return actors;
    }

    public void setActors(String actors) {
        this.actors = actors;
    }

    public String getActorAscii() {
        return actorAscii;
    }

    public void setActorAscii(String actorAscii) {
        this.actorAscii = actorAscii;
    }

    public String getDirector() {
        return director;
    }

    public void setDirector(String director) {
        this.director = director;
    }

    public String getDirectorAscii() {
        return directorAscii;
    }

    public void setDirectorAscii(String directorAscii) {
        this.directorAscii = directorAscii;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Boolean getType() {
        return type;
    }

    public void setType(Boolean type) {
        this.type = type;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    public Integer getViews() {
        return views;
    }

    public void setViews(Integer views) {
        this.views = views;
    }

    public String getUploadDay() {
        return uploadDay;
    }

    public void setUploadDay(String uploadDay) {
        this.uploadDay = uploadDay;
    }

    public String getTrailer() {
        return trailer;
    }

    public void setTrailer(String trailer) {
        this.trailer = trailer;
    }

    public Boolean getStatus() {
        return status;
    }

    public void setStatus(Boolean status) {
        this.status = status;
    }

    public String getQuantity() {
        return quantity;
    }

    public void setQuantity(String quantity) {
        this.quantity = quantity;
    }

    public Boolean getAgeLimit() {
        return ageLimit;
    }

    public void setAgeLimit(Boolean ageLimit) {
        this.ageLimit = ageLimit;
    }

    public Boolean getVipOnly() {
        return vipOnly;
    }

    public void setVipOnly(Boolean vipOnly) {
        this.vipOnly = vipOnly;
    }

    @XmlTransient
    public Collection<Genre> getGenreCollection() {
        return genreCollection;
    }

    public void setGenreCollection(Collection<Genre> genreCollection) {
        this.genreCollection = genreCollection;
    }

    @XmlTransient
    public Collection<Episode> getEpisodeCollection() {
        return episodeCollection;
    }

    public void setEpisodeCollection(Collection<Episode> episodeCollection) {
        this.episodeCollection = episodeCollection;
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

    public Country getCountryId() {
        return countryId;
    }

    public void setCountryId(Country countryId) {
        this.countryId = countryId;
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
        hash += (movieId != null ? movieId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Movies)) {
            return false;
        }
        Movies other = (Movies) object;
        if ((this.movieId == null && other.movieId != null) || (this.movieId != null && !this.movieId.equals(other.movieId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entity.Movies[ movieId=" + movieId + " ]";
    }
    
}
