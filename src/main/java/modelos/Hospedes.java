package modelos;

public class Hospedes {
    
    private int idHospede;
    private String nome;
    private String senha;
    private String telefone;
    private String email;

    public Hospedes() {}

    public Hospedes(String nome, String senha, String telefone, String email) {
        this.nome = nome;
        this.senha = senha;
        this.telefone = telefone;
        this.email = email;
    }

    // --- Getters e Setters ---

    public int getIdHospede() {
        return idHospede;
    }

    public void setIdHospede(int idHospede) {
        this.idHospede = idHospede;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getSenha() {
        return senha;
    }

    public void setSenha(String senha) {
        this.senha = senha;
    }

    public String getTelefone() {
        return telefone;
    }

    public void setTelefone(String telefone) {
        this.telefone = telefone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    @Override
    public String toString() {
        return "Hospede [ID=" + idHospede + ", Nome=" + nome + ", Senha=" + senha +
               ", Telefone=" + telefone + ", Email=" + email + "]";
    }
}