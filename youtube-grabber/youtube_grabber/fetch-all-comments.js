const Task = require('data.task')
const fetchComments = require('youtube-comments-task')

const fetchAllComments = (videoId, pageToken, fetched = []) =>
  fetchComments(videoId, pageToken)
    .chain(({ comments, nextPageToken }) =>
      nextPageToken
        ? fetchAllComments(videoId, nextPageToken, fetched.concat(comments))
        : Task.of(fetched.concat(comments)))
 
fetchAllComments(process.argv[2])
  .fork(e => console.error('ERROR', e),
        allComments => console.log(allComments))
