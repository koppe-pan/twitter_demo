import * as React from 'react';
import Tweet from '../components/Tweet';
import Main from '../components/Main';
type Props = { props:any };
type State = { tweets: Array<any>, segment: string};

class HomePage extends React.Component<Props, State> {
  constructor(props: any) {
    super(props);
    this.state = {
      tweets: [],
      segment: "Global"
    };
  }

  componentDidMount() {
    fetch("/api/tweets")
    .then(res => res.json())
    .then(
      (res) => {
        this.setState({
          tweets: res.tweets,
          segment: "Global"
        });
      },

      (err) => {
        console.error(err);
      }
      )
  }

  toggle = (e:any) => {
    let url, headers;
      e.persist()
    if(e.target.value == 'myfeed'){
      url ="/api/tweets/feed/?name="+ localStorage.getItem("username");
      headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer "+localStorage.getItem("token")
      }
    } else {
      url = "/api/tweets";
      headers = {
        "Content-Type": "application/json",
      }
    }
    fetch(url, {
      method: 'GET',
      headers: headers
    })
    .then(res => res.json())
    .then(
      (res) => {
        this.setState({
          tweets: res.tweets,
          segment: e.target.value
        });
      },
      (err) => {
        console.error(err);
      }
      )
  }
  render() {
    return(
      <Main>
          {localStorage.getItem("isLogin") === "true" ?
          <>
            <label>みんなの投稿</label>
            <input type="radio" onChange={this.toggle} value="Global" checked = {this.state.segment==='Global'}></input>
            <label>フォロワーの投稿</label>
            <input type="radio" onChange={this.toggle} value="myfeed" checked = {this.state.segment==='myfeed'}></input>
          </>
          : <p>みんなの投稿</p>}
        <div>
          <p>Tweets</p>
          {this.state.tweets.map((art: any, index: number) =>
            <Tweet key={art.slug} description={art.description} favorited={art.favorited} favoritesCount={art.favoritesCount} slug={art.slug} author={art.author}></Tweet>)}
        </div>
      </Main>
    );
  }
}

export default HomePage
