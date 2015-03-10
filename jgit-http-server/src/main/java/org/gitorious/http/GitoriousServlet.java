/*
 *   Copyright (C) 2011 Gitorious AS
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU Affero General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Affero General Public License for more details.
 *
 *   You should have received a copy of the GNU Affero General Public License
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

package org.gitorious.http;
import org.eclipse.jgit.http.server.*;
import javax.servlet.ServletException;
import org.eclipse.jgit.http.server.resolver.*;
import javax.servlet.http.HttpServletRequest;
import org.eclipse.jgit.lib.Repository;
import org.eclipse.jgit.transport.ReceivePack;

/*
 * Extending JGit's GitServlet to use a custom repository resolver 
 */
public class GitoriousServlet extends GitServlet {
    public GitoriousServlet() {
    }

    public void init() throws ServletException {
        String repositoryRoot = getServletConfig().getInitParameter("repository_root");
        String permissionBaseUri = getServletConfig().getInitParameter("permission_base_uri");

        GitoriousResolver resolver = new GitoriousResolver();
        resolver.setRepositoryRoot(repositoryRoot);
        resolver.setPermissionBaseUri(permissionBaseUri);
        setRepositoryResolver(resolver);

        setReceivePackFactory(new GitoriousReceivePackFactory());
    }

    class GitoriousReceivePackFactory implements ReceivePackFactory {
        public ReceivePack create(HttpServletRequest req, Repository db) throws ServiceNotEnabledException, ServiceNotAuthorizedException {
            System.err.println("ACCESS DENIED for " + db.toString() + "/" + req.getRemoteUser());
            //throw new ServiceNotEnabledException();
            throw new ServiceNotAuthorizedException();
        }
    }
}