/*
* ClockModule
*/

import React from 'react';
import moment from 'moment';


export default class ClockModule extends React.Component { // eslint-disable-line react/prefer-stateless-function

  static propTypes = {
    layout: React.PropTypes.string,
  };

  constructor(props) {
    super(props);

    this.state = {
      time: moment(),
    };

    this.timer = null;
  }

  componentDidMount() {
    console.log(this.props);
    this.timer = setInterval(() => {
      this.setState({
        time: moment(),
      });
    }, 1000);
  }

  componentWillUnmount() {
    clearInterval(this.timer);
  }

  render() {
    if (this.props.hasOwnProperty('layout') && this.props.layout == "heading") {
      return (
        <div className="col-xs-12">
            <h4>{this.state.time.format('HH:mm')} <small>{this.state.time.format('dddd, Do MMMM YYYY')}</small></h4>
        </div>
      )
    }
    return (
      <div className="col-sm-12">
        <div className="col-sm-12">
          <h2>{this.state.time.format('HH:mm')}<sub><small>{this.state.time.format('ss')}</small></sub></h2>
        </div>
        <div className="col-sm-12">
          <h5>{this.state.time.format('dddd, Do MMMM YYYY')}</h5>
        </div>
      </div>
    );
  }
}
