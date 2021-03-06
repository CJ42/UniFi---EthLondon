import React, { Component } from 'react';
import Web3 from 'web3';
// import Identicon from 'identicon.js';
// import './App.css';
// import SocialNetwork from '../abis/SocialNetwork.json'
// Front end / other stuff
import Navbar from './Navbar'
import Content from './Content'
// import Menubar from './Menubar'
// import Main from './Main'
// import Home from "./Level1";
// import Stuff from "./Level2";
// import Contact from "./Level3";
// import {
//   Route,
//   NavLink,
//   HashRouter
// } from "react-router-dom";



class App extends Component {

  async componentWillMount() {
    await this.loadWeb3()
    await this.loadBlockchainData()
  }

  async loadWeb3() {
    if (window.ethereum) {
      window.web3 = new Web3(window.ethereum)
      await window.ethereum.enable()
    }
    else if (window.web3) {
      window.web3 = new Web3(window.web3.currentProvider)
    }
    else {
      window.alert('Non-Ethereum browser detected. You should consider trying MetaMask!')
    }
  }

  async loadBlockchainData() {

    const web3 = window.web3

    // Load account
    const accounts = await web3.eth.getAccounts()
    this.setState({ account: accounts[0] })

    // Network ID
    // const networkId = await web3.eth.net.getId()
    // const networkData = SocialNetwork.networks[networkId]
    
    // if(networkData) {
     
    // } else {
    //   window.alert('SocialNetwork contract not deployed to detected network.')
    // }
  }


  // constructor(props) {
  //   super(props)
  //   this.state = {
  //     account: '',
  //     socialNetwork: null,
  //     postCount: 0,
  //     posts: [],
  //     loading: true
  //   }

  //   this.createPost = this.createPost.bind(this)
  //   this.tipPost = this.tipPost.bind(this)
  // }

  constructor(props) {
    super(props)
    this.state = {
      account: ''
      // socialNetwork: null,
      // postCount: 0,
      // posts: [],
      // loading: true
    }
  }

  render() {
    return (
      <div>
        <Navbar account={this.state.account} />
        <Content />
      </div>
    );
  }
}

export default App;