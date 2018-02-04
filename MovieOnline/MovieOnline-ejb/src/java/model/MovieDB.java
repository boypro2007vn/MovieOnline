/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package model;

import java.io.Serializable;
import javax.persistence.*;

/**
 *
 * @author namin
 */
@Entity
public class MovieDB implements Serializable{
    private static final long serialVersionUID = 1L;
    @Id
    @Column(name = "movieId")
    private int movieId;
    @Column(name = "title")
    private String title;
    @Column(name = "realTitle")
    private String realTitle;
    @Column(name = "titleTag")
    private String titleTag;
    @Column(name = "releaseDay")
    private String releaseDay;
    @Column(name = "countryName")
    private String countryName;
    @Column(name = "genre")
    private String genre;
    @Column(name = "imdb")
    private float imdb;
    @Column(name = "rate")
    private float rate;
    @Column(name = "ratecount")
    private int ratecount;
    @Column(name = "actors")
    private String actors;
    @Column(name = "director")
    private String director;
    @Column(name = "description")
    private String description;
    @Column(name = "type")
    private boolean type;
    @Column(name = "currentEpisode")
    private int currentEpisode;
    @Column(name = "numberEpisode")
    private int numberEpisode;
    @Column(name = "duration")
    private String duration;
    @Column(name = "views")
    private int views;
    @Column(name = "trailer")
    private String trailer;
    @Column(name = "status")
    private boolean status;
    @Column(name = "quantity")
    private String quantity;
    @Column(name = "ageLimit")
    private boolean ageLimit;
    @Column(name = "vipOnly")
    private boolean vipOnly;
    @Column(name = "follow")
    private boolean follow;

    public int getMovieId() {
        return movieId;
    }

    public void setMovieId(int movieId) {
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

    public String getCountryName() {
        return countryName;
    }

    public void setCountryName(String countryName) {
        this.countryName = countryName;
    }

    public String getGenre() {
        return genre;
    }

    public void setGenre(String genre) {
        this.genre = genre;
    }

    public float getImdb() {
        return imdb;
    }

    public void setImdb(int imdb) {
        this.imdb = imdb;
    }

    public float getRate() {
        return rate;
    }

    public void setRate(float rate) {
        this.rate = rate;
    }

    public int getRatecount() {
        return ratecount;
    }

    public void setRatecount(int ratecount) {
        this.ratecount = ratecount;
    }

    public String getActors() {
        return actors;
    }

    public void setActors(String actors) {
        this.actors = actors;
    }

    public String getDirector() {
        return director;
    }

    public void setDirector(String director) {
        this.director = director;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isType() {
        return type;
    }

    public void setType(boolean type) {
        this.type = type;
    }
    
    public int getCurrentEpisode() {
        return currentEpisode;
    }

    public void setCurrentEpisode(int currentEpisode) {
        this.currentEpisode = currentEpisode;
    }

    public int getNumberEpisode() {
        return numberEpisode;
    }

    public void setNumberEpisode(int numberEpisode) {
        this.numberEpisode = numberEpisode;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    public int getViews() {
        return views;
    }

    public void setViews(int views) {
        this.views = views;
    }

    public String getTrailer() {
        return trailer;
    }

    public void setTrailer(String trailer) {
        this.trailer = trailer;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public String getQuantity() {
        return quantity;
    }

    public void setQuantity(String quantity) {
        this.quantity = quantity;
    }

    public boolean isAgeLimit() {
        return ageLimit;
    }

    public void setAgeLimit(boolean ageLimit) {
        this.ageLimit = ageLimit;
    }

    public boolean isVipOnly() {
        return vipOnly;
    }

    public void setVipOnly(boolean vipOnly) {
        this.vipOnly = vipOnly;
    }

    public boolean isFollow() {
        return follow;
    }

    public void setFollow(boolean follow) {
        this.follow = follow;
    }
    
    
}
