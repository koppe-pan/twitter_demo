import * as React from 'react';
import Main from '../components/Main';

type Props = { props:any };
type State = { username: string, password: string, email: string, introduction: string};

class SettingsPage extends React.Component <Props, State> {

  constructor(props: any) {
    super(props);

    this.state = {
      username: '',
      password: '',
      email: '',
      introduction: ''
    };
  }

  updateUserName = (event: any) => {
    event.persist()
    this.setState({ username: event.target.value});
  };

  updateEmail = (event: any) => {
    event.persist()
    this.setState({ email: event.target.value});
  };

  updatePassword = (event: any) => {
    event.persist()
    this.setState({ password: event.target.value});
  };

  updateIntroduction = (event: any) => {
    event.persist()
    this.setState({ introduction: event.target.value});
  };

  componentDidMount() {
    let url = "/api/user/" + localStorage.getItem("username");

    fetch(url, {
      method: 'GET',
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + localStorage.getItem("token")
      },
    })
    .then(res => res.json())
    .then(
      (result) => {
        this.setState({username: result.data.name, email: result.data.email})
      },
      (error) => {

        console.error(error);
      }
    )
  }

  updateSetting = () => {
    let credentials;
    credentials = {
      "user": {
        "name": this.state.username,
        "introduction": this.state.introduction
      }
    }
    if(this.state.password != '') {
      credentials = {
        "user": {
          "name": this.state.username,
          "introduction": this.state.introduction,
          "password": this.state.password
        }
      }
    }
    fetch("/api/user/" + localStorage.getItem("username"), {
      method: 'PUT',
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + localStorage.getItem("token")
      },
      body: JSON.stringify(credentials)
    })
    .then(res => res.json())
    .then(
      (result) => {
        localStorage.setItem("token",result.data.token);
      },
      (error) => {
        console.error(error);
      }
    )
  }
  render(){
    return(
      <Main>
          <label>Username</label>
          <input onChange={this.updateUserName} type="text" placeholder="username" value={this.state.username}></input>
          <label>Email</label>
          <input onChange={this.updateEmail} type="email" placeholder="email" value={this.state.email}></input>
          <label>Password</label>
          <input onChange={this.updatePassword} type="password" placeholder="password" value={this.state.password}></input>
          <label>Introduction</label>
          <input onChange={this.updateIntroduction} type="text" placeholder="introduction" value={this.state.introduction}></input>
          <button color="success" onClick={this.updateSetting}>Update Settings</button>
      </Main>
      )
  }
}
export default SettingsPage
