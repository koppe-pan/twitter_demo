import * as React from 'react';
import { RouteComponentProps } from 'react-router-dom';
import * as Showdown from "showdown";
import Comment from '../components/Comment';

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
    this.converter = new Showdown.Converter({
      tables: true,
      simplifiedAutoLink: true,
      strikethrough: true,
      tasklists: true,
      requireSpaceBeforeHeadingText: true
    });
  }
  converter: any;
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
    let url = "/tweet/"+ this.props.match.params.slug;
    let commentUrl = url + '/comments';
    let headers: any;

    Promise.all([this.fetchTweet(url), this.fetchTweet(commentUrl)]).then(
      (result) => {
        this.setState({
          tweet: result[0].tweet,
          author: result[0].author,
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
    let url = "/articles/"+ this.props.match.params.slug;
    let commentUrl = url + '/comments';
    let body = {
      "comment": {
        "body": this.state.comment
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
      newComments.push(com.comment);
      this.setState({comments: newComments, comment: ''})
    })
  }
  viewAuthor = () => {
    this.props.history.replace('/profile/'+ this.state.author.username)
  }

  render() {
    let tweet = this.state.tweet;
    let author = this.state.author;
    return (
      <>
        {tweet.description}
        <button onClick={this.viewAuthor}>{author.username}</button>
        {new Intl.DateTimeFormat('en-US', {
          year: 'numeric',
          month: 'long',
          day: '2-digit'
        }).format(new Date(tweet.createdAt ? tweet.createdAt : 0))}
        <hr />
          <div dangerouslySetInnerHTML={ { __html: this.converter.makeHtml(tweet.body)}}></div>
          <hr className="horizontal-line" />
            {this.state.comments.length > 0 ?
              <div>
                {this.state.comments.map((art: any, index: number) =>
                  <Comment key={art.id} body={art.body} slug={this.state.tweet.slug} createdAt={art.createdAt}
                    commentId={art.id} username={art.author.username} onDeleteComment={this.deleteComment}></Comment>
                )}
              </div>:<p>No Comments</p>}
              <div>
              {localStorage.getItem("isLogin") === "true" ?
                <form action="">
                  <input type="text" onChange={this.updateComment} placeholder="Write a comment" value={this.state.comment}></input>
                  <button onClick={this.addComment}>Add Comment</button>
                </form>
                : <></>}
              </div>
    </>
  );
  }
}
export default TweetPage
