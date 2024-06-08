import api, { route } from '@forge/api';

export const run = async (event, context) => {
  
  const { workspace, repository, pullrequest } = event;
  const workspaceId = workspace.uuid;
  const repoSlug = repository.uuid;
  const pullRequestId = pullrequest.id;

  const isSuccess = false;

  try {
    const pullRequestResponse = await api.asApp()
              .requestBitbucket(route`2.0/repositories/${workspaceId}/${repoSlug}/pullrequests/${pullRequestId}`);
    const pr = await pullRequestResponse.json();
    if(pullRequestResponse.ok) {
      const commit = pr.source.commit.hash;
      const commitResponse = await api.asApp()
                                      .requestBitbucket(route`/2.0/repositories/${workspaceId}/${repoSlug}/src/${commit}/.bitbucket/CODEOWNERS`);
      const data = await commitResponse.json();
      console.log({data});
      console.log(data.error.detail);
    }
  } catch (err) {
    console.error(err.message);
  }
  
  const message = isSuccess ? "Pull request is ready to be merged." : "Pull request is not ready to be merged.";
  return {
    success: isSuccess,
    message: message
  };
};