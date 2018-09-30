class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :sort)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    
    if params[:ratings] != session[:ratings] || params[:sort] != session[:sort]
      if params[:commit]
        session[:ratings] = params[:ratings]
      elsif params[:sort]
        session[:sort] = params[:sort]
      end
      flash.keep
      redirect_to(movies_path(:ratings => session[:ratings],:sort => session[:sort]))
    else
      @all_ratings = Movie.all_ratings
      sort = params[:sort]
      @sort = sort
      
      unless params[:ratings]
        @selected_ratings = @all_ratings
      else
        @selected_ratings = params[:ratings].keys
      end
      
      if sort == "title"
        @movies = Movie.order(:title).where(:rating => @selected_ratings)
      elsif sort == "date"
        @movies = Movie.order(:release_date).where(:rating => @selected_ratings)
      else
        @movies = Movie.all.where(:rating => @selected_ratings)
      end
      
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
