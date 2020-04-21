import * as React from 'react';
import { RouteComponentProps } from 'react-router-dom';
import Comment from '../components/Comment';
import Tweet from '../components/Tweet';
import Main from '../components/Main';

type Props ={
}
type State = {
  tweet: any,
  author: any,
  comments: any,
  comment: string
}

class TweetPage extends React.Component<Props & RouteComponentProps<any>, State> {
  constructor(props: any){
    super(props);

    this.state = {
      tweet: '',
      author: '',
      comments: [],
      comment: ''
    }
  }
  fetchTweet(url: string){
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
    let url = "/api/tweets/"+ this.props.match.params.slug;
    let commentUrl = url + '/comments';
    let headers: any;
    let tweetUrl;
    if(localStorage.getItem("isLogin") && localStorage.getItem("isLogin") == "true"){
      tweetUrl = url + '/?name=' + localStorage.getItem("username")
    }else{
      tweetUrl = url
    }

    Promise.all([this.fetchTweet(tweetUrl), this.fetchTweet(commentUrl)]).then(
      (result) => {
        this.setState({
          tweet: result[0].data,
          author: result[0].data.author,
          comments: result[1].comments
        })
      }
    )
  }

  updateComment = (event: any) => {
    event.persist()
    this.setState({ comment: event.target.value});
  }
  deleteComment = (e: any) => {
    this.setState({
      comments: this.state.comments.filter((com: any) => com.id !== e)
    })
  }
  addComment = () => {
    let url = "/api/tweets/"+ this.props.match.params.slug;
    let commentUrl = url + '/comments';
    let body = {
      "comment": {
        "body": this.state.comment,
        "author": localStorage.getItem("username")
      }
    }
    fetch(commentUrl, {
      method: 'POST',
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer "+ localStorage.getItem("token")
      },
      body: JSON.stringify(body)
    }).then(res => res.json())
    .then((com) => {
      let newComments = this.state.comments;
      newComments.push(com.data);
      this.setState({comments: newComments, comment: ''})
    })
  }
  viewAuthor = () => {
    this.props.history.replace('/profile/'+ this.state.author)
  }

  render() {
    let tweet = this.state.tweet;
    let author = this.state.author;
    return (
      <Main>
        <div style={{textAlign: "right"}}>
          {new Intl.DateTimeFormat('en-US', {
            year: 'numeric',
            month: 'long',
            day: '2-digit'
          }).format(new Date(tweet.createdAt ? tweet.createdAt : 0))}
        </div>
        <Tweet key={tweet.slug} description={tweet.description} favorited={tweet.favorited} favoritesCount={tweet.favoritesCount} slug={tweet.slug} author={tweet.author}></Tweet>
        <hr />
          <hr className="horizontal-line" />
            {this.state.comments.length > 0 ?
              <div>
                {this.state.comments.map((art: any, index: number) =>
                  <Comment key={art.id} body={art.body} slug={this.state.tweet.slug} createdAt={art.createdAt}
                    commentId={art.id} username={art.author} onDeleteComment={this.deleteComment}></Comment>
                )}
              </div>:<p>No Comments</p>}
              <div>
              {localStorage.getItem("isLogin") === "true" ?
                <>
                  <input type="text" onChange={this.updateComment} placeholder="Write a comment" value={this.state.comment}></input>
                  <button onClick={this.addComment}>Add Comment</button>
                </>
                : <></>}
              </div>
    </Main>
  );
  }
}
export default TweetPage
