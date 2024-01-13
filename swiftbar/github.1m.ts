#!/opt/homebrew/bin/bun
import { graphql } from '@octokit/graphql'
import { formatDistanceToNow } from 'date-fns'
import dotenv from 'dotenv'
import _ from 'lodash'
import xbar, { Options, separator } from 'xbar'

dotenv.config({ path: __dirname + '/.env' })

const main = async () => {
  const {
    search: { edges: pullRequests },
  } = await graphql(
    `
      {
        search(
          first: 100
          query: "-author:@me is:open team-review-requested:supabase/backend type:pr"
          type: ISSUE
        ) {
          edges {
            node {
              ... on PullRequest {
                author {
                  login
                }
                body
                createdAt
                files(first: 100) {
                  edges {
                    node {
                      additions
                      changeType
                      deletions
                      path
                    }
                  }
                }
                number
                repository {
                  nameWithOwner
                }
                title
                updatedAt
                url
              }
            }
          }
          issueCount
        }
      }
    `,
    {
      headers: {
        authorization: `token ${process.env.GITHUB_PERSONAL_ACCESS_TOKEN}`,
      },
    }
  )

  const oneWeekAgo = new Date()
  oneWeekAgo.setDate(oneWeekAgo.getDate() - 7)

  const relevantPRs = pullRequests.filter(
    ({
      node: {
        author: { login },
        files: { edges: files },
        title,
        updatedAt,
      },
    }) =>
      new Date(updatedAt) > oneWeekAgo &&
      login !== 'dependabot' &&
      (title.includes('hotfix') ||
        _.sumBy(files, 'node.additions') < 10 ||
        !files.every(({ node: { path } }) => path.startsWith('api/')))
  )

  if (!process.env.SWIFTBAR) {
    console.log(JSON.stringify(relevantPRs, null, 2))
  }

  const menuItems: Array<(Options & { md: boolean }) | typeof separator> = []

  for (const {
    node: {
      author: { login },
      body,
      createdAt,
      files: { edges: files },
      number,
      repository: { nameWithOwner },
      title,
      updatedAt,
      url,
    },
  } of relevantPRs) {
    menuItems.push({
      href: url,
      md: true,
      submenu: files.map(({ node: { additions, changeType, deletions, path } }) => ({
        href: `${url}/files`,
        text: `${
          changeType === 'CHANGED' ? 'T' : changeType[0]
        } ${path} (+${additions} -${deletions})`,
      })),
      text: `**${title}**\n\n${body
        .replace(/(\r\n)+/g, '\n')
        .replace(/\s+$/g, '')
        .split('\n')
        .slice(0, 10)
        .join('\n')}\n\n*${nameWithOwner}#${number} opened ${formatDistanceToNow(createdAt, {
        addSuffix: true,
      })} by ${login} • updated ${formatDistanceToNow(updatedAt, {
        addSuffix: true,
      })}*`,
    })
    menuItems.push(separator)
  }

  xbar([
    {
      text: `${relevantPRs.length} PRs`,
    },
    separator,
    ...menuItems,
  ])
}

void main()
