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
import javax.persistence.Lob;
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
@Table(name = "Episode", catalog = "F21603S1_MovieOnline", schema = "dbo")
@XmlRootElement
@NamedStoredProcedureQueries({
    @NamedStoredProcedureQuery(
            name = "Episode.getEpisodeByMovieIDStorePro",
            procedureName = "getLinkMovie",
            resultClasses = Episode.class,
            parameters = {@StoredProcedureParameter(name = "movieId",mode = ParameterMode.IN,type = Integer.class)}
    ),
    @NamedStoredProcedureQuery(
            name = "Episode.getChangeEpisode",
            procedureName = "getChangeEpisode",
            resultClasses = Episode.class,
            parameters = {@StoredProcedureParameter(name = "episodeId",mode = ParameterMode.IN,type = Integer.class)}
    )
})
@NamedQueries({
    @NamedQuery(name = "Episode.findAll", query = "SELECT e FROM Episode e"),
    @NamedQuery(name = "Episode.findByMovieId", query = "SELECT e FROM Episode e WHERE e.movieId = :movieId"),
    @NamedQuery(name = "Episode.findByEpisodeId", query = "SELECT e FROM Episode e WHERE e.episodeId = :episodeId"),
    @NamedQuery(name = "Episode.findByEpisodeName", query = "SELECT e FROM Episode e WHERE e.episodeName = :episodeName"),
    @NamedQuery(name = "Episode.findByMovieIdandEpisodeName", query = "SELECT e FROM Episode e WHERE e.movieId = :movieId and e.episodeName= :episodeName"),
    @NamedQuery(name = "Episode.findByLanguage", query = "SELECT e FROM Episode e WHERE e.language = :language"),
    @NamedQuery(name = "Episode.findByRes360", query = "SELECT e FROM Episode e WHERE e.res360 = :res360"),
    @NamedQuery(name = "Episode.findByRes480", query = "SELECT e FROM Episode e WHERE e.res480 = :res480"),
    @NamedQuery(name = "Episode.findByRes720", query = "SELECT e FROM Episode e WHERE e.res720 = :res720"),
    @NamedQuery(name = "Episode.findByRes1080", query = "SELECT e FROM Episode e WHERE e.res1080 = :res1080"),
    @NamedQuery(name = "Episode.findByBroken", query = "SELECT e FROM Episode e WHERE e.broken = :broken")})
public class Episode implements Serializable {
    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "episodeId", nullable = false)
    private Integer episodeId;
    @Basic(optional = false)
    @NotNull
    @Column(name = "episodeName", nullable = false)
    private double episodeName;
    @Basic(optional = false)
    @NotNull
    @Size(min = 1, max = 20)
    @Column(name = "language", nullable = false, length = 20)
    private String language;
    @Size(max = 50)
    @Column(name = "res360", length = 50)
    private String res360;
    @Size(max = 50)
    @Column(name = "res480", length = 50)
    private String res480;
    @Size(max = 50)
    @Column(name = "res720", length = 50)
    private String res720;
    @Size(max = 50)
    @Column(name = "res1080", length = 50)
    private String res1080;
    @Lob
    @Size(max = 2147483647)
    @Column(name = "subtitle", length = 2147483647)
    private String subtitle;
    @Column(name = "broken")
    private Boolean broken;
    @JoinColumn(name = "movieId", referencedColumnName = "movieId")
    @ManyToOne(fetch = FetchType.LAZY)
    private Movies movieId;

    public Episode() {
    }

    public Episode(Integer episodeId) {
        this.episodeId = episodeId;
    }

    public Episode(Integer episodeId, double episodeName, String language) {
        this.episodeId = episodeId;
        this.episodeName = episodeName;
        this.language = language;
    }

    public Integer getEpisodeId() {
        return episodeId;
    }

    public void setEpisodeId(Integer episodeId) {
        this.episodeId = episodeId;
    }

    public double getEpisodeName() {
        return episodeName;
    }

    public void setEpisodeName(double episodeName) {
        this.episodeName = episodeName;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getRes360() {
        return res360;
    }

    public void setRes360(String res360) {
        this.res360 = res360;
    }

    public String getRes480() {
        return res480;
    }

    public void setRes480(String res480) {
        this.res480 = res480;
    }

    public String getRes720() {
        return res720;
    }

    public void setRes720(String res720) {
        this.res720 = res720;
    }

    public String getRes1080() {
        return res1080;
    }

    public void setRes1080(String res1080) {
        this.res1080 = res1080;
    }

    public String getSubtitle() {
        return subtitle;
    }

    public void setSubtitle(String subtitle) {
        this.subtitle = subtitle;
    }

    public Boolean getBroken() {
        return broken;
    }

    public void setBroken(Boolean broken) {
        this.broken = broken;
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
        hash += (episodeId != null ? episodeId.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Episode)) {
            return false;
        }
        Episode other = (Episode) object;
        if ((this.episodeId == null && other.episodeId != null) || (this.episodeId != null && !this.episodeId.equals(other.episodeId))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "entity.Episode[ episodeId=" + episodeId + " ]";
    }
    
}
