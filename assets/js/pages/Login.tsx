import * as React from 'react';
import {RouteComponentProps} from 'react-router';
import { Link } from 'react-router-dom';

import Main from '../components/Main';

type Props = { props:any };
type State = {username: string, password: string, toastState: boolean, toastMessage: string, action:string, email: string};

export default class LoginPage extends React.Component <Props & RouteComponentProps<any>, State> {

  constructor(props: any) {
    super(props);
    this.state = {
      username: '',
      password: '',
      toastState: false,
      toastMessage: 'Message',
      action: "Login",
      email: ''
    };
    this.event = new CustomEvent('loggedIn', {
      detail: false
    });
  }
  event: Event;

  updateUserName = (event: any) => {
    this.setState({ username: event.detail.value });
  };

   updatePassword = (event: any) => {
     this.setState({ password: event.detail.value });
   };

   updateEmail = (event: any) => {
     this.setState({ email: event.detail.value });
   };

   toggleAction = () => {
     this.state.action === 'Login' ? this.setState({action: 'SignUp'}) : this.setState({action: 'Login'})
   }

  componentDidMount(){
    this.clearCredentials();
    this.props.history.listen((location, action) => {
      if(location.pathname == "/login"){
        this.clearCredentials();
      }
    })
  }

  clearCredentials(){
    this.event = new CustomEvent('loggedIn', {
      detail: false
    });
    window.dispatchEvent(this.event);
    localStorage.removeItem("token");
    localStorage.removeItem("username");
    localStorage.removeItem("isLogin");
    localStorage.removeItem("email");
  }

  login= () => {
    let url, credentials;
    if(this.state.action == 'Login'){
      url = '/api/sign_in';
      credentials = {
        "session": {
          "email": this.state.email,
          "password": this.state.password
        }
      }
    }else{
      url = '/api/users';
      credentials = {
        "user": {
          "email": this.state.email,
          "password": this.state.password,
          "username": this.state.username
        }
      }
    }
    fetch(url, {
      method: 'POST',
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(credentials)
    })
    .then((res) => {
      if(res.status == 200){
        return res.json();
      }else {
        if(this.state.action == 'SignUp') {
          throw new Error("Error creating user");
        } else {
          throw new Error("Error Logging in")
        }
      }
    })
    .then(
      (result) => {
        localStorage.setItem("username", result.data.name);
        localStorage.setItem("isLogin", "true");
        localStorage.setItem("email", result.data.email);

        this.event = new CustomEvent('loggedIn', {
          detail: true,
        });
        window.dispatchEvent(this.event);
        this.props.history.replace('/');
      },
      (error) => {
        console.error(error);
        this.setState({toastMessage: error.toString(), toastState: true});
      }
      )
    }
  public render(): JSX.Element {
    return (
      <Main>
        <h1>Log In</h1>
        <p>
          This component demonstrates fetching data from the Phoenix API
          endpoint.
        </p>
        <form action="">
          <input onChange={this.updateEmail} type="email" placeholder="Email"></input>
          {this.state.action === 'SignUp' ?
            <input onChange={this.updateUserName} type="text" placeholder="Username"></input> : <></> }
          <input onChange={this.updatePassword} type="password" placeholder="Password"></input>
        </form>
        <button onClick={this.login}>{this.state.action}</button>
        <br />
        <br />
        <p>
          Click here to <a onClick={this.toggleAction}>{this.state.action === 'Login'? 'SignUp' : 'Login'}</a>
        </p>
      </Main>
    );
  }
}
