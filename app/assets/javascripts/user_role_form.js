UC.UserRoleForm = function UserRoleForm(dom) {
  this.$ = $(dom);
};

UC.UserRoleForm.find = function findUserRoleForms() {
  $('form.user_role').each(function(dom) {
    new UC.UserRoleForm(dom);
  });
}
