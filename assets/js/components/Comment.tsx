import * as React from 'react';

type Props = {
  body: string,
  username: string,
  createdAt: string
  commentId: number,
  slug: string,
  key: string,
  onDeleteComment: any;
}

class Comment extends React.Component<Props, any> {
  constructor(props: Props){
    super(props);
  }
  deleteComment = (params: any) => {
    let url = "/tweet/" + this.props.slug + '/comments/' + this.props.commentId;
    fetch(url, {
      method: 'DELETE',
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer "+ localStorage.getItem("token"),
      }
    })
    .then(res => res.json())
    .then(
      (res) => {
        this.props.onDeleteComment(this.props.commentId)
      },

      (err) => {
        console.error(err);
      }
      )
  }

  render() {
    return (
      <>
      <p>{this.props.body}</p>
      <div>
        <span>
          {this.props.username}
          {new Intl.DateTimeFormat('en-US', {
            year: 'numeric',
            month: 'long',
            day: '2-digit'
          }).format(new Date(this.props.createdAt))}
        </span>
        {this.props.username == localStorage.getItem("username") ?
          <span>
            <button onClick={this.deleteComment}>消す</button>
          </span>: <></>
        }
      </div>
    </>
    )
    };
}
export default Comment
