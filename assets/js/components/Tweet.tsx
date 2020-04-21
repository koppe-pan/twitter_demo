import * as React from 'react';
import { Link } from 'react-router-dom';
import '../../css/Tweet.css';

import Main from '../components/Main'

type Props = {
  description: string,
  favorited: boolean,
  favoritesCount: number,
  slug: string,
  author: string
}

type State = {
  favorited: boolean,
  favoritesCount: number
}

class Tweet extends React.Component<Props, State> {
  constructor(props: Props){
    super(props);

    this.state = {
      favorited: this.props.favorited,
      favoritesCount: this.props.favoritesCount
    }
    this.routeLink = '/tweetpage/'+this.props.slug;
    this.profileLink = '/profile/'+this.props.author;
  }
  routeLink: string;
  profileLink: string;

  favoriteTweet = (params: any) => {
    let url = "/api/tweets/" + this.props.slug + '/favorite/'+localStorage.getItem("username");
    let method;
    if(!this.state.favorited) {
      method = 'POST'
    }else{
      method = "DELETE"
    }
    fetch(url, {
      method: method,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + localStorage.getItem("token"),
      }
    })
    .then(res => res.json())
    .then(
      (res) => {
        this.setState({
          favorited: res.favorited,
          favoritesCount: res.favorites,
        })
      },
      (err) => {
        console.error(err);
      }
    )
  }

  loggedIn(){
    return (
      <>
      {this.loggedOut()}
      <button color={this.state.favorited ? "blue": "red"} onClick={this.favoriteTweet}>
        {this.state.favorited ? "いいね解除": "いいね"}
      </button>
       いいね数：{this.state.favoritesCount}
      </>
    )
  }

  loggedOut(){
    return(
      <>
        <div className="author">
          <Link className="link" to= {this.profileLink}>{this.props.author}</Link>
          <h2 className="description">{this.props.description}</h2>
        </div>
        <div style={{textAlign: "right"}}>
          <Link className="link" to= {this.routeLink}>Read More</Link>
        </div>
      </>
    )
  }
  render() {
    return (
      <>
      {localStorage.getItem("isLogin") === "true" ? this.loggedIn() : this.loggedOut()}
      </>
    );
  }
}

export default Tweet
