export class MailInfo {
  private recipient: string | undefined;
  private sender: string | undefined;
  private subject: string | undefined;
  private emailContent: string | undefined;

  constructor(recipient: string | undefined, sender: string | undefined, subject: string | undefined, emailContent: string | undefined) {
    this.recipient = recipient;
    this.sender = sender;
    this.subject = subject;
    this.emailContent = emailContent;
  }
}