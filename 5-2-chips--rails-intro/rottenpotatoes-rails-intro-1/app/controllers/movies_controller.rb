class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    if params[:ratings] == nil && params[:sort] == nil #+something in seesion
      redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
    end
    
   
    
    
    @ratings_to_show =  params[:ratings] || {'G'=>'1','PG'=>'1','PG-13'=>'1','R'=>'1' }
    session[:ratings] = @ratings_to_show
    
    if params[:sort] != nil 
      session[:sort] = params[:sort]
    end
    
    order = session[:sort] || nil
    if order == 'title' 
      @title_header =  'hilite bg-warning'
    elsif order == 'release_date'
      @release_date_header = 'hilite bg-warning'
    end 

    @movies = Movie.with_ratings(@ratings_to_show.keys).order(order)
    
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
