import * as React from 'react';
import '../../css/Tweet.css';
import Main from '../components/Main'
import { RouteComponentProps } from 'react-router';

type Props = { props: {
  match: any
}};
type State = {description: string}

class NewTweet extends React.Component<Props & RouteComponentProps, State> {
  constructor(props: any) {
    super(props);
    this.state = {
      description: '',
    };

  }
  descriptionChange = (event: any) => {
    event.persist()
    this.setState({ description: event.target.value});
  }
  submitTweet = (tag: any) =>{
    let tweetData = {
      "tweet": {
        "description": this.state.description,
        "author": localStorage.getItem("username")
      }
    }
    fetch("/api/tweets", {
      method: 'POST',
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer "+ localStorage.getItem("token")
      },
      body: JSON.stringify(tweetData)
    })
    .then(res => res.json())
    .then(
    (result) => {
      this.setState({
        description: "",
      })
    },
    (error) => {
      console.error(error);
    }
    )
  }
  render(){
    return(
      <Main>
        <input onChange={this.descriptionChange} type="text" placeholder="write Tweet" value={this.state.description}></input>
        <button onClick={this.submitTweet}>ツイート</button>
      </Main>
    )
  }
}
export default NewTweet
