import * as React from 'react';
import ReactMde from 'react-mde';
import "react-mde/lib/styles/css/react-mde-all.css";
import * as Showdown from "showdown";
import '../../css/Tweet.css';
import { RouteComponentProps } from 'react-router';

type Props = { props: {
  match: any
}};
type State = { error: any,  isLoaded: boolean, value: any, tab: any, description: string}

class NewTweet extends React.Component<Props & RouteComponentProps, State> {
  constructor(props: any) {
    super(props);
    this.state = {
      error: null,
      isLoaded: false,
      value: "Tweet your tweet",
      tab: "write",
      description: '',
    };

    this.setEditor = (editor: any) => {
      this.editor = editor;
    };
    this.focusEditor = () => {
      if (this.editor) {
        this.editor.focus();
      }
    };

    this.converter = new Showdown.Converter({
      tables: true,
      simplifiedAutoLink: true,
      strikethrough: true,
      tasklists: true
    });
  }

  setEditor: any;
  editor: any;
  focusEditor: any;
  converter: any;
  handleTabChange = (tab: any) => {
    this.setState({ tab });
  };
  descriptionChange = (event: any) => {
    event.persist()
    this.setState({ description: event.target.value});
  }
  submitTweet = (tag: any) =>{
    let tweetData = {
      "description": this.state.description,
      "author": localStorage.getItem("username")
    }
    fetch("/tweets", {
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
      <>
      <form onSubmit={this.submitTweet}>
        <ReactMde
        onChange={this.descriptionChange}
        onTabChange={this.handleTabChange}
        value={this.state.description}
        selectedTab={this.state.tab}
        generateMarkdownPreview={markdown =>
          Promise.resolve(this.converter.makeHtml(markdown))
        }
        />
      </form>
    </>
    )
  }
}
export default NewTweet
