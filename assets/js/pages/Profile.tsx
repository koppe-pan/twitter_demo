import * as React from 'react';
import { RouteComponentProps } from 'react-router-dom';
import Tweet from '../components/Tweet';

import Main from '../components/Main';

type Props = {
}

type State = {
  profile: any,
  tweetsAuthor: any,
  isFollowing: boolean,
  introduction: string,
}

class ProfilePage extends React.Component<Props & RouteComponentProps<any>, State> {
  constructor(props: any){
    super(props);

    this.state = {
      profile: '',
      tweetsAuthor: [],
      isFollowing: false,
      introduction: '',
    }
  }

  fetchTweets(url: string){
    let headers;
    if(localStorage.getItem("isLogin") && localStorage.getItem("isLogin") == "true"){
      headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer "+ localStorage.getItem("token")
      }
    }else{
      headers = {
        "Content-Type": "application/json",
      }
    }
    return fetch(url, {
      method: 'GET',
        headers: headers,
    }).then((res) => res.json())
  }
  componentDidMount() {
    let profileUrl
    if(localStorage.getItem("isLogin") && localStorage.getItem("isLogin") == "true"){
      profileUrl = "/api/profiles/" + this.props.match.params.authorname + "/?username=" + localStorage.getItem("username") ;
    }else{
      profileUrl = "/api/profiles/" + this.props.match.params.authorname ;
    }
    let tweetsByProfileUrl = "/api/tweets/?author="+ this.props.match.params.authorname + "&user=" + localStorage.getItem("username") ;

     Promise.all([this.fetchTweets(profileUrl), this.fetchTweets(tweetsByProfileUrl)]).then((result) => {

       this.setState({
         profile: result[0].profile.name,
         tweetsAuthor: result[1].tweets,
         isFollowing: result[0].profile.following,
         introduction: result[0].profile.introduction
       });

     }).catch(err => {
       console.error(err);
     })
  }
  settings = (event: any) => {
    this.props.history.push('/settings');
  }
  followUser = (e: any) => {
    let profileUrl
    let method;
    if(this.state.isFollowing){
      method = 'DELETE'
      profileUrl = "/api/profiles/" + this.props.match.params.authorname + '/unfollow/'+ localStorage.getItem("username") ;
    }else{
      method = 'POST'
      profileUrl = "/api/profiles/" + this.props.match.params.authorname + '/follow/'+ localStorage.getItem("username") ;
    }
    fetch(profileUrl, {
      method: method,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer "+ localStorage.getItem("token")
      }
    }).then((res) => {
      if(!this.state.isFollowing){
        this.setState({
          isFollowing: !this.state.isFollowing,
        })
        res.json()
      }else{
        if(res.status == 204){
          this.setState({
            isFollowing: !this.state.isFollowing,
          })
        }
      }
    })
  }

  render() {
    return (
      <Main>
        <h1>{this.state.profile}</h1>
        <h2>{this.state.introduction}</h2>
        <hr />
        {localStorage.getItem("isLogin")=== "true" ?
          <>
          {localStorage.getItem("username") === this.state.profile?
            <button onClick={this.settings}>Settings</button>
          : <button onClick={this.followUser}>{this.state.isFollowing ? "Unfollow" : "Follow"}</button>}
          </>
        : <> </>}
        <div>
          <p>Tweets</p>
          {this.state.tweetsAuthor.map((art: any, index: number) =>
            <Tweet key={art.slug} description={art.description} favorited={art.favorited} favoritesCount={art.favoritesCount} slug={art.slug} author={art.author}></Tweet>)}
        </div>
      </Main>
    );
  }
}

export default ProfilePage
