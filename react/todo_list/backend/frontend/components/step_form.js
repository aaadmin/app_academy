import React, { Component } from 'react';
import { connect } from 'react-redux';
import { receiveStep } from '../actions/step_actions';
import { receiveTodo } from '../actions/todo_actions';
import { bindActionCreators } from 'redux';
import { uniqueId } from '../util/id_generator';

class StepForm extends Component {
  constructor(props){
    super(props);

    this.state = {
      title: '',
      body: '',
      done: false
    };

    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleChange = this.handleChange.bind(this);
  }

  handleSubmit(e){
    e.preventDefault();
    let step = Object.assign(
      {},
      this.state,
      { todo_id: this.props.todo.id, id: uniqueId() }
    );

    let newTodo = Object.assign(
      {},
      this.props.todo,
      { stepsHidden: false }
    );

    this.props.receiveStep(step);
    this.props.receiveTodo(newTodo);
    this.setState({
      title: '',
      body: '',
      done: false
    });
  }

  handleChange(property){
    return e => this.setState({ [property]: e.target.value });
  }

  render(){
    return (
        <form
          className={`step-form${this.props.todo.stepFormHidden ? ' hide' : ''}`}
          onSubmit={this.handleSubmit}>
          <label>add note
            <input
              type='text'
              placeholder='Buy chips'
              value={ this.state.title }
              onChange={ this.handleChange('title') }
              />
          </label>
          <br />
          <label>details
            <textarea
              placeholder='Remember that Jessica is gluten-free'
              value={ this.state.body }
              onChange={ this.handleChange('body') }
              />
          </label>
          <br />
          <button className='submit-btn' type='submit'>add note</button>
        </form>
    );
  }
}

const mapDispatchToProps = dispatch => {
  return bindActionCreators({ receiveStep, receiveTodo }, dispatch);
};

export default connect(null, mapDispatchToProps)(StepForm);
